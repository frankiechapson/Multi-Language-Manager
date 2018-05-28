# Multi Language Manager

## Oracle SQL and PL/SQL solution to manage more than one language 


## Introduction

Often there is a need to create a *„multi-language”* system. But what does it really mean *„multi-language”* system?  
Usually at this time they were only used to think that menu items and label of GUI-s are displayed in a different language. Of course, there is a need, but multilingualism is much more. What about the data? How about an English user, if the label is displayed on the UX was that "State" instead of the "Státusz", but the "9 – Hibás tartalom" field content will no longer be understood.  
When this problem becomes apparent, it is often the developers started to move the database side data into the GUI or MW side, and/or in XML files.   
This is completely wrong and unsustainable process because any new data means GUI change and needs a new program version release. On the other hand, the data must be in the database! And not just one or two LOV text to be translated, but for example a whole product list, which could means housands of data rows.  
The right way is the opposite. Instead of moving data to the GUI side, put the GUI Texts into the database.  

**The method is the following:**  
The database has a default language. This language is what the data was entered. However, some tables, some columns could be representation on other languages as well.  
Both the base and the other languages has addtional settings, eg date formats, fonts, sorting, text comparison, etc., These are Oracle NLS settings.  
MLM provides a solution to add more languages to a system (extend it) without touching the original/base one.  
Plus with the langauge changing, we can change the session NLS settings too.  
Unfortunately there is a disadvantage. You can forget the indeces on the translated columns.  

## How does it work?
First we have to define the languages and optionally their NLS settings. See chapter Tables!  
After this we can change the current language with PKG_MLM.SET_LANGUAGE procedure.  
This SET_LANGUGAE procedure does not only execute the alter session set commands but set three global (context) variable value as well. Because there are three global context varable:
- Number of languages
- Default language ID and 
- CODE

The second thing to enter transalations to **ML_TRANSLATIONS** table.  
The content of the tables for this simple example: 

    select * from ML_LANGUAGES;
    ID    CODE    TEXT             IS_DEFAULT
     1     HUN    Magyar           Y
     2     USA    Amerikai Angol   N

    select * from ML_SCHEMAS;
    ID     NAME
     1     CA

    select * from ML_TABLES;
    ID   SCHEMA_ID    NAME
     1           1    ML_LANGUAGES

    select * from ML_COLUMNS;
    ID   TABLE_ID   NAME
     1          1   TEXT

    select * from ML_TRANSLATIONS;
    ID  LANGUAGE_ID  COLUMN_ID  ROW_PK  TEXT
     1            2          1       1  Hungarian
     2            2          1       2  American English
 
The third thing to use the GET_TEXT function to display translatable texts instead of displaying them directly. Practically use views instead of simple selects:

    exec pkg_mlm.SET_LANGUAGE('USA');

    select id
         , code
         , pkg_mlm.get_text( 'CA', 'ML_LANGUAGES', 'TEXT', ID , TEXT ) as TEXT 
    from ML_LANGUAGES;

    ID  CODE  TEXT
     1  HUN   Hungarian
     2  USA   American English

    exec pkg_mlm.SET_LANGUAGE('HUN');

    -- the same select
    select id
         , code
         , pkg_mlm.get_text( 'CA', 'ML_LANGUAGES', 'TEXT', ID , TEXT ) as TEXT 
    from ML_LANGUAGES;

    ID  CODE  TEXT
     1  HUN   Magyar
     2  USA   Amerikai Angol
 
As we can see, after the changing the language, the same select produces different output.  
Because the GET_TEXT function returns with 5th parameter if the current language is the default. So the data is in the default language and that is the currently selected. So nothing to do just display the original db data. It is fast.  
If the default language and the selected differs, then it gets the appropriate translation from the ML_TRANSLATIONS table specified with schema, table, column name and the row PK (ID in this case).  
So the the first 4 parameter is a key structure to get the right translation.

**That’s it!**

## Tables

### ML_LANGUAGES
The list of usable, selectable languages. If our system use single language, we can use MLM to setup the right NLS settings independently from database default.
The column **IS_DEFAULT** flag defines the default languae (the language of data). „Y” means Yes, and „N” means No.  
There must be exactly one default language!

### ML_NLS_PARAMETERS
The list of selectable NLS parameters. We can use for any other session parameter settings too, because at language change the procedure will execute

    alter session set  parameter = setting

commands and the „parameter” will come from this table. This could be the source of a drop down on UX.
 
### ML_NLS_SETTINGS
The NLS parameter values what belongs to a specific language and specific NLS parameter. 

### ML_SCHEMAS, ML_TABLES, ML_COLUMNS
The MLM uses the standard **Schema-Table-Column-Row** structure to specify a data. This is important because the **WRITE_TRANSLATION_FILE** procedure checks the specified tables to find the missing transalations.  
In Chapter *Introduction* I told that the right way not to move data to client side, but move client data, labels and titles into the database. So, the best practice to create a UX_TEXTS table and put every UX text into. After that we can  create translations to them here in MLM.

### ML_TRANSLATIONS
The transaltions itselfs. A row contains the language, to column reference, the PK of the row and the translated text.


## Views

There are some **ML_..._VW** to help the work and identify the data, because these views tipically show the CODE and/or NAME and not only ID-s of the references.

## MLM package

The most of  procedures and functions have a telling names and are very simple, for example **GET_LANGUAGE_ID** returns with the ID of the current/selected language.  
But there are some important one:

    procedure ADD_TRANSLATION ( I_LANGUAGE_CODE       in varchar2,
                                I_SCHEMA_NAME         in varchar2,
                                I_TABLE_NAME          in varchar2,
                                I_COLUMN_NAME         in varchar2,
                                I_ROW_PK              in nvarchar2, 
                                I_TEXT                in nvarchar2
                              ) 
for example:

    PKG_MLM.ADD_TRANSLATION( 'USA', 'CA', 'ML_LANGUAGES', 'TEXT', 2, 'American English' );

The previously described **SET_LANGUAGE** and **GET_TEXT**, and the

### WRITE_TRANSLATION_FILE
This procedure is very useful to generate file for interpreters.

    procedure  WRITE_TRANSLATION_FILE( I_LANGUAGE_CODE  in varchar2 := null
                                     , I_ONLY_MISSING   in char     := null
                                     , I_DIRECTORY      in varchar2 := null
                                     , I_FILE_NAME      in varchar2 := null
                                     )

The parameters

- *I_LANGUAGE_CODE*	The langauge code of the translation. If it is null, then the every non-default language will be writen out.
- *I_ONLY_MISSING*		If ’Y’ then the procedure will write out only the missing translations. Default is ’N’ 
- *I_DIRECTORY*		The Oracle directory for the output file. If missing the output will be the dbms output.
- *I_FILE_NAME*		The name of the output pile.

Example:

    execute PKG_MLM.WRITE_TRANSLATION_FILE;

Output on DBMS Output:

    PROMPT **********************************************************
    PROMPT **         T R A N S L A T I O N S   U S A              **
    PROMPT **********************************************************
    /*********************************/
    PROMPT  ML_LANGUAGES
    /*********************************/
    execute PKG_MLM.ADD_TRANSLATION( 'USA', 'CA', 'ML_LANGUAGES', 'TEXT', 1, 'Magyar' );
    execute PKG_MLM.ADD_TRANSLATION( 'USA', 'CA', 'ML_LANGUAGES', 'TEXT', 2, 'Amerikai Angol' );
    commit;

If we gave this file to a Hungarian – English Translator to replace the Hungarian texts at the end of commands and execute the result as a script, it will add/replace the USA language translations in the database.

