 //
//  FirstViewController.m
//  portalecbahia
//
//  Created by Antonio Lazaro Carvalho Borges on 21/11/12.
//  Copyright (c) 2012 Antonio Lazaro Carvalho Borges. All rights reserved.
//

#import "FirstViewController.h"
#import "NewDetailViewController.h"
#import "AFJSONRequestOperation.h"

@interface FirstViewController ()

@end

@implementation FirstViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createDataBase];
    self.tableNews.dataSource = self;
    self.tableNews.delegate = self;
	[self fetchNews];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) createDataBase{
    NSString *docsDir;
    NSArray *dirPaths;
    
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(
                                                   NSDocumentDirectory, NSUserDomainMask, YES);
    
    docsDir = dirPaths[0];
    
    // Build the path to the database file
    _databasePath = [[NSString alloc]
                     initWithString: [docsDir stringByAppendingPathComponent:
                                      @"portalecbahia-apk-db"]];
    
    NSFileManager *filemgr = [NSFileManager defaultManager];
    
    if ([filemgr fileExistsAtPath: _databasePath ] == NO)
    {
        const char *dbpath = [_databasePath UTF8String];
        
        if (sqlite3_open(dbpath, &_newsDB) == SQLITE_OK)
        {
            [self database:_newsDB createTable:"CREATE TABLE IF NOT EXISTS tbl_news (ID INTEGER NOT NULL PRIMARY KEY,position INTEGER NOT NULL  ,title VARCHAR,urlImage VARCHAR,date DATETIME,content VARCHAR,urlWebSite VARCHAR)"];
            
            [self database:_newsDB createTable:"CREATE TABLE IF NOT EXISTS tbl_media (ID INTEGER PRIMARY KEY  NOT NULL ,title VARCHAR,urlImage VARCHAR,time VARCHAR,date DATETIME,urlMedia VARCHAR,typeID INTEGER)"];
            
            [self database:_newsDB createTable:"CREATE TABLE IF NOT EXISTS tbl_match (ID INTEGER PRIMARY KEY  NOT NULL ,championshipName VARCHAR,stadimName VARCHAR,stadiumId VARCHAR,awayTeamName VARCHAR,awayTeamUrlImage VARCHAR,homeTeamName VARCHAR,homeTeamUrlImage VARCHAR,date DATETIME,dateUTC DATETIME,homeGoal INTEGER,awayGoal INTEGER,finished INTEGER,homeTeamShortName VARCHAR,awayTeamShortName VARCHAR,live INTEGER)"];
            
            [self database:_newsDB createTable:"CREATE TABLE IF NOT EXISTS tbl_actions (ID INTEGER PRIMARY KEY  NOT NULL , idMatch INTEGER NOT NULL,description VARCHAR,minute INTEGER,type INTEGER,team VARCHAR)"];
            
            [self database:_newsDB createTable:"CREATE TABLE IF NOT EXISTS tbl_last_update_action (ID INTEGER PRIMARY KEY  NOT NULL ,idMatch INTEGER NOT NULL,date DATETIME)"];
            
            [self database:_newsDB createTable:"CREATE TABLE IF NOT EXISTS tbl_rankings (ID INTEGER PRIMARY KEY  NOT NULL,position INTEGER NOT NULL,team VARCHAR,points INTEGER NOT NULL,games INTEGER NOT NULL,wins INTEGER NOT NULL,draws INTEGER NOT NULL,losses INTEGER NOT NULL,goalDifference INTEGER NOT NULL,championshipId INTEGER NOT NULL)"];
            
            [self database:_newsDB createTable:"CREATE TABLE IF NOT EXISTS tbl_stadium (ID INTEGER PRIMARY KEY  NOT NULL,name VARCHAR NOT NULL,capacity VARCHAR,urlImage VARCHAR NOT NULL,dateInauguration VARCHAR NOT NULL,latitude VARCHAR NOT NULL,longitude VARCHAR NOT NULL,description VARCHAR NOT NULL)"];
            
            [self database:_newsDB createTable:"CREATE TABLE IF NOT EXISTS tbl_player (ID INTEGER PRIMARY KEY  NOT NULL ,position VARCHAR,idPosition VARCHAR,name VARCHAR,urlImage INTEGER,description VARCHAR)"];
            
            [self database:_newsDB createTable:"CREATE TABLE IF NOT EXISTS tbl_notification (ENABLE INTEGER NOT NULL )"];

            
            sqlite3_close(_newsDB);
        } else {
            NSLog(@"Falha ao abrir ou conectar o banco...");
        }
    }
}

-(BOOL) database:(sqlite3 *)newsDB createTable:(char *)sql{
    char *errMsg;
    const char *sql_stmt = sql;
    BOOL retornoExecucao = (sqlite3_exec(_newsDB, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK);
    if (retornoExecucao){
        //_status.text = @"Failed to create table";
        NSLog(@"Falha ao criar tabela tbl_news...");
    }
    return retornoExecucao;
}

- (void) saveNews{
    
    sqlite3_stmt    *statement;
    const char *dbpath = [_databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &_newsDB) == SQLITE_OK){
        
        for (int i = 0; i < [news count]; i++){
            
            NSDictionary *new = [news objectAtIndex:i];
            
            NSLog(@"Vai salvar a noticia %@ ",[new objectForKey:@"title"]);
            
            NSDateFormatter *format = [[NSDateFormatter alloc] init];
            [format setDateFormat:@"yyyy-MM-dd HH:mm"];
            NSDate *dataFormatada = [format dateFromString:[new objectForKey:@"date"]];
            
            NSString *insertSQL = [NSString stringWithFormat:
                                   @"INSERT INTO tbl_news (ID,position,  title, urlImage, date, content, urlWebSite)  VALUES (%d,%d,'%@','%@','%@','%@','%@')",
                                   [[new objectForKey:@"id"] intValue],//int
                                   [[new objectForKey:@"position"] intValue],//int
                                   [[new objectForKey:@"title"] description],//varchar
                                   [[new objectForKey:@"urlImage"]description],//varchar
                                   dataFormatada,//datetime
                                   [[new objectForKey:@"content"]description],//varchar
                                   [[new objectForKey:@"urlWebSite"]description]];//varchar
            
            const char *insert_stmt = [insertSQL UTF8String];
            sqlite3_prepare_v2(_newsDB, insert_stmt,
                               -1, &statement, NULL);
            
            int retornoOperacao = sqlite3_step(statement);
            if (retornoOperacao == SQLITE_DONE){
                NSLog(@"Noticia adicionada com sucesso.");
            }else {
                NSLog(@"%s",sqlite3_errmsg(_newsDB));
                NSLog(@"Codigo do erro ao adicionar noticia %d ",retornoOperacao);
            }
        }
        sqlite3_finalize(statement);
        sqlite3_close(_newsDB);
    }
}

-(NSArray *) findNews{
    
    sqlite3_stmt *statement = nil;
    const char *sql = [@"SELECT position, ID,title,urlImage,date,content,urlWebSite FROM tbl_news order by date desc limit 0,20" UTF8String];
    
    const char *dbpath = [_databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &_newsDB) == SQLITE_OK){
        
        int retornoConexao = sqlite3_prepare_v2(_newsDB, sql, -1, &statement, NULL);
        
        if (retornoConexao != SQLITE_OK) {
            NSLog(@"%s",sqlite3_errmsg(_newsDB));
            NSLog(@"[SQLITE] Error preparando consulta de news! %d",retornoConexao);
        } else {
            NSMutableArray *result = [NSMutableArray array];
            
            while (sqlite3_step(statement) == SQLITE_ROW) {
                
                NSMutableDictionary *row = [[NSMutableDictionary alloc] init];
                
                for (int i=0; i<sqlite3_column_count(statement); i++) {
                    
                    int colType = sqlite3_column_type(statement, i);
                    char *colName = (char *) sqlite3_column_name(statement, i);
                    
                    id value;
                    
                    if (colType == SQLITE_TEXT) {
                        char *chars = (char*)sqlite3_column_text(statement, i);
                        value = [NSString stringWithUTF8String:chars];
                    } else if (colType == SQLITE_INTEGER) {
                        int col = sqlite3_column_int(statement, i);
                        value = [NSNumber numberWithInt:col];
                    } else if (colType == SQLITE_FLOAT) {
                        double col = sqlite3_column_double(statement, i);
                        value = [NSNumber numberWithDouble:col];
                    } else if (colType == SQLITE_NULL) {
                        value = [NSNull null];
                    } else {
                        NSLog(@"[SQLITE] UNKNOWN DATATYPE");
                    }
                    
                    [row setObject:value forKey:[NSString stringWithUTF8String:colName]];
                }
                [result addObject:row];
            }
            return result;
        }
    }
    return nil;
}


- (void)fetchNews
{
   
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSData* data = [NSData dataWithContentsOfURL:
                        [NSURL URLWithString: @"http://ec2-54-243-134-2.compute-1.amazonaws.com:8080/portalECBahia/FindAllNews"]];
        
        NSError* error;
        
        NSDictionary *newsDicctionary = [NSJSONSerialization JSONObjectWithData:data
                                                 options:kNilOptions
                                                   error:&error];
    
        news = [newsDicctionary objectForKey:@"data"];
        
        NSLog(@"@ vai salvar noticias que foram carregadas via JSON...");
        [self saveNews];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableNews reloadData];
        });
        
    });
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"quantidade de noticias...%d",news.count);
    return news.count-1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row != 0){
        return 75;
    }else{
        return 200;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        news = [self findNews];
    
        static NSString *CellIdentifier = @"NewsCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
    
        NSDictionary *new = [news objectAtIndex:indexPath.row];
        NSString *dateString = [new objectForKey:@"date"];
        
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        [format setDateFormat:@"yyyy-MM-dd HH:mm"];
        NSDate *dataFormatada = [format dateFromString:dateString];
        
        [format setDateStyle:NSDateFormatterLongStyle];
        [format setTimeStyle:NSDateFormatterShortStyle];
        dateString = [format stringFromDate:dataFormatada];
        
        
        cell.textLabel.text = dateString;
        cell.textLabel.font = [UIFont boldSystemFontOfSize:10];
    
        NSLog(@"%@",[new objectForKey:@"title"]);
        NSLog(@"%d",indexPath.row);
    
    
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        cell.detailTextLabel.text = [new objectForKey:@"title"];
        cell.detailTextLabel.font = [UIFont boldSystemFontOfSize:12];
        NSURL *url = [NSURL URLWithString:[new objectForKey:@"urlImage"]];
        NSData *data = [NSData dataWithContentsOfURL:url];
        UIImage *image = [[UIImage alloc] initWithData:data];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        
        CGSize itemSize;
        if(indexPath.row != 0){
            itemSize = CGSizeMake(75, 75);
        }else{
            itemSize = CGSizeMake(200,300);
        }
        UIGraphicsBeginImageContext(itemSize);
        CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
        [imageView.image drawInRect:imageRect];
        cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
       });
//    }
    
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"segueNewDetail"]) {
        
        NSInteger row = [[self tableNews].indexPathForSelectedRow row];
        
        NSDictionary *new = [news objectAtIndex:row];
        
        NewDetailViewController *newDetailViewController = segue.destinationViewController;
        newDetailViewController.detailItem = new;

    }
}


@end
