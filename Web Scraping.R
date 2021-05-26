#Import Libraries
library(rvest)
library(dplyr)
library(lubridate)
library(stringr)

#Web-Scrapping to Get Most Recent Data
#------------------------------------------------------------------------------------------------------------------------------
EventsInfo=data.frame()
EventsUrl=c()
for (k in 1:6){ # For loop to pull event URL suffixes
  EventUrl=read_html(paste('http://www.sherdog.com/organizations/Ultimate-Fighting-Chanmpionship-2/recent-events/',k,sep=''))
  EventInfo=EventUrl %>% html_nodes('table') %>% html_table() #pull table
  EventsInfo=rbind(EventsInfo,as.data.frame(EventInfo[2])[-1,]) #Bind rows, set as Dataframe and delete non-used column
  EventUrl=EventUrl %>% html_nodes('td') %>% html_nodes('a') %>% html_attr('href')
  EventsUrl=append(EventsUrl,EventUrl[-(1:8)]) #Delete non-used column
}

EventsUrl=sapply(EventsUrl,function(x) paste('http://sherdog.com',x,sep='')) #Lambda function to get list of event Urls
Fights_Scrapped=data.frame() #Create empty Dataframe
for (i in seq(1,length(EventsUrl))){ #For loop to feed in all event URLs
  Event=read_html(EventsUrl[i])
  Result=Event %>% html_nodes('table') %>% html_table() #Read in Event Tables
  #Part 1
  Result_p1=as.data.frame(Result[2]) #Take Data from table and apply If statement to filter
  if (nrow(Result_p1)!=0){
    colnames(Result_p1)=c('Match','Fighter1','vs','Fighter2','Method','Round','Time')
    #Delete Title Row
    Result_p1=Result_p1[-1,]
    n=nrow(Result_p1)
    #Delete 'vs' Column
    Result_p1=Result_p1[,-3]
    #Seperate Method Column
    Result_p1$Referee=sapply(Result_p1$Method,function(x) gsub('^(.*)\\)','',x))
    Result_p1$Method_D=sapply(Result_p1$Method,function(x) gsub('\\)(.*)','',gsub('^(.*)\\(','',x)))
    Result_p1$Method=sapply(Result_p1$Method,function(x) gsub('\\(.*','',x))
    
    #Fighter Url
    Fighter_p1=Event %>% html_nodes('.fighter_result_data a') %>% html_attr('href')
    Fighter_p1=as.data.frame(matrix(Fighter_p1,ncol=2,byrow=TRUE))
    colnames(Fighter_p1)=c('Fighter1_url','Fighter2_url')
    
    rownames(Result_p1)=NULL
    Result_p1=cbind(Result_p1,Fighter_p1)
    
    #Part 2
    Result_p2=Result[1]
    #Format match number
    Result_p2=sapply(Result_p2,function(x) sub('^([a-zA-Z]* )','',x))
    Result_p2=as.data.frame(t(Result_p2))
    
    colnames(Result_p2)=c('Match','Method','Referee','Round','Time')
    
    #Name of fighters
    temp=Event %>% html_nodes('.right_side a span , .left_side a span') %>% html_text()
    Result_p2$Fighter1=temp[1]
    Result_p2$Fighter2=temp[2]
    
    #Seperate Method Column
    Result_p2$Method_D=sapply(Result_p2$Method,function(x) gsub('\\)(.*)','',gsub('^(.*)\\(','',x)))
    Result_p2$Method=sapply(Result_p2$Method,function(x) gsub('\\(.*','',x))
    
    #Fighters URL
    temp1=Event %>% html_nodes('.left_side a') %>% html_attr('href')
    Result_p2$Fighter1_url=temp1[1]
    temp2=Event %>% html_nodes('.right_side a') %>% html_attr('href')
    Result_p2$Fighter2_url=temp2[1]
    
    #Fight Date & Location
    D_L=Event %>% html_nodes('.authors_info span') %>% html_text()
    
    #Bind together
    Final=rbind(Result_p1,Result_p2)
    Final$Event_Name=EventsInfo[i,2]
    Final$Event_id=gsub('.*-','',EventsUrl[i])
    Final$Date=D_L[1]
    Final$Location=D_L[2]
    Fights_Scrapped=rbind(Fights_Scrapped,Final)
  }
  print(i) # Print Statement to show progress
}
Fights_Scrapped=as.data.frame(Fights_Scrapped) # Set as Dataframe

Fights=sapply(Fights_Scrapped,function(x) ifelse(x=='N/A',NA,x)) #Rename strings NAs to readable NA Format
Fights=as.data.frame(Fights) #Set Fights as Dataframe
Tfmt='%M:%S' #Set time format as variable
Fights$Time=strptime(Fights$Time,format=Tfmt) #Apply Time Format

Fighters_Scrapped=data.frame()
#Get Fighters' URL
Fighters_URL=sapply(unique(c(as.character(Fights_Scrapped$Fighter1_url),as.character(Fights_Scrapped$Fighter2_url))),function(x) paste('http://sherdog.com',x,sep=''))
for(j in seq(1,length(Fighters_URL))){ #For loop to pull in fighter Data
  Fighter=read_html(Fighters_URL[j])
  Result=Fighter %>% html_nodes('strong, .locality, .birthday span,.vcard h1') %>% html_text() #Read in Figher data
  Fighter_got=as.data.frame(t(Result[1:9])) #Set as Dataframe
  colnames(Fighter_got)=c('Name','Birth_Date','Age','Birth_Place','Country','Height','Weight','Association','Class') #Rename Columns
  Fighter_got$Fighter_id=gsub('.*-','',Fighters_URL[j])
  Fighters_Scrapped=rbind(Fighters_Scrapped,Fighter_got) #Bind Rows
  
  print(j)# Print Statement to show progress
}

Fighters_Backup=Fighters_Scrapped

#Data Cleaning

Error=Fighters_Scrapped[Fighters_Scrapped$Class==' VS ',c(1:10)] #see if there are fighters with misaligned columns
Fighters_Scrapped=Fighters_Scrapped[Fighters_Scrapped$Class!=' VS ',] #Take out errors

#Error Type 1
Error_p1=Error[grepl('lbs',Error$Height),] #Find Vectors that have lbs in height column
Error=Error[!grepl('lbs',Error$Height),] #Find Vectors that have lbs in height colum

#Error Type 2
Error_p2=Error_p1[c(6,13),]
Error_p1=Error_p1[-c(6,13),]
colnames(Error_p2)=c('Birth_Date','Age','Birth_Place','Country','Height','Weight','Association','Class','Fighter_id','Url')
Error_p2$Name=c('Mirsad Bektic','Noad Lahat')

#Error Type 3
Error_p3=Error_p1[Error_p1$Association==Error_p1$Association[3],c(1:7,9,10)]
Error_p1=Error_p1[!Error_p1$Association==Error_p1$Association[3],]
colnames(Error_p3)=c('Name','Birth_Date','Age','Country','Height','Weight','Class','Fighter_id','Url')

#Rename Columns in Error Dataframes
colnames(Error_p1)=c('Name','Birth_Date','Age','Country','Height','Weight','Association','Class','Fighter_id','Url')
colnames(Error)=c('Name','Birth_Date','Age','Birth_Place','Country','Height','Weight','Class','Fighter_id','Url')


Fighters_Scrapped=rbind.fill(Fighters_Scrapped,Error,Error_p1,Error_p2,Error_p3)
Fighters_Scrapped$NickName=sapply(Fighters_Scrapped$Name,function(x) gsub('\\"','',regmatches(x,gregexpr('"[^"]*"',x))[[1]])) #Split Nicknames into own column 
Fighters_Scrapped$Name=sapply(Fighters_Scrapped$Name,function(x) gsub('\\".*\\"','',x))#Split Names into own column
Fighters_Scrapped$Age=sapply(Fighters_Scrapped$Age,function(x) gsub('AGE: ','',x)) #Remove Age: String
Fighters_Scrapped$Feet=sapply(Fighters_Scrapped$Height,function(x) gsub("\\'.*",'',x)) #Remove unnecessary strings from Height
Fighters_Scrapped$Inch=sapply(Fighters_Scrapped$Height,function(x) gsub('\\"','',gsub(".\\'",'',x))) #Remove unnecessary strings from Height
Fighters_Scrapped$Height=as.integer(as.character(Fighters_Scrapped$Feet))*12 + as.integer(as.character(Fighters_Scrapped$Inch)) #Convert Height to Total Inches
Fighters_Scrapped$Weight=sapply(Fighters_Scrapped$Weight,function(x) gsub(' lbs','',x)) #Remove unnecessary strings from Weight
Fighters_Scrapped=sapply(Fighters_Scrapped, function(x) gsub('N/A',NA,x)) #Rename strings NAs to readable NA Format
Fighters_Scrapped=as.data.frame(Fighters_Scrapped) #Make data as Dataframe
Fighters_Scrapped$Birth_Date=ymd(Fighters_Scrapped$Birth_Date) #Apply Date Time format 


#Data Formatting
#-----------------------------------------------------------------------------------------------------------------------------

Fighters_Updated=Fighters_Scrapped
Fighters_Updated$Fighter_id=as.integer(Fighters_Updated$Fighter_id)
Fighters_Updated=Fighters_Updated[!duplicated(Fighters_Updated$Fighter_id),]
rownames(Fighters_Updated)=NULL

Fighters_Updated$Birth_Date=ymd(as.character(Fighters_Updated$Birth_Date))
Fighters_Updated$Name=as.character(Fighters_Updated$Name)
Fighters_Updated$NickName=as.character(Fighters_Updated$NickName)

Fighters_Updated$Height=as.integer(Fighters_Updated$Height)
Fighters_Updated$Weight=as.integer(Fighters_Updated$Weight)
Fighters_Updated[,7:10]=sapply(Fighters_Updated[,c(7:9,11)],function(x) as.character(x))
Fighters_Updated[,7:10]=sapply(Fighters_Updated[,c(7:9,11)],function(x) ifelse(x %in% c("",'N/A'),NA,x))
for (i in seq(7,10)){
  Fighters_Updated[,i]=as.factor(Fighters_Updated[,i])
}


#Scraping Event Location Data
#-----------------------------------------------------------------------------------------------------------------------------
Stadiums=count(EventsInfo,X3)
#Stadiums$x=as.character((Stadiums$x))



#Save Result as CSV
#-----------------------------------------------------------------------------------------------------------------------------
write.csv(Fighters_Updated,'Fighters_Updated.csv')
write.csv(Fights_Scrapped,'Fights_Updated.csv')
write.csv(EventsInfo,'EventsInfo.csv')
#write.csv(Stadiums,'Stadiums.csv')