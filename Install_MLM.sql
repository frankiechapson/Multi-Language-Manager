/************************************************************
    Author  :   Ferenc Toth
    Remark  :   Multi Language Support Solution
    Date    :   2015.07.01
************************************************************/



Prompt *****************************************************************
Prompt **         I N S T A L L I N G   M U L T I L A N G             **
Prompt *****************************************************************


/*============================================================================================*/
CREATE SEQUENCE ML_SEQ_ID
/*============================================================================================*/
    INCREMENT BY        1
    MINVALUE            1
    MAXVALUE   9999999999
    START WITH       1000
    CYCLE
    NOCACHE;


/*============================================================================================*/
CREATE OR REPLACE CONTEXT MLM USING ML_CONTEXT ACCESSED GLOBALLY;
/*============================================================================================*/

/*============================================================================================*/
CREATE OR REPLACE PACKAGE ML_CONTEXT IS
/*============================================================================================*/
    PROCEDURE SET_CONTEXT( I_ATTRIBUTE IN VARCHAR2, I_VALUE IN VARCHAR2 );
END;
/

/*============================================================================================*/
CREATE OR REPLACE PACKAGE BODY ML_CONTEXT IS
/*============================================================================================*/

    PROCEDURE SET_CONTEXT( I_ATTRIBUTE IN VARCHAR2, I_VALUE IN VARCHAR2 ) IS
    BEGIN
        DBMS_SESSION.SET_CONTEXT( NAMESPACE  => 'MLM',
                                  ATTRIBUTE  => I_ATTRIBUTE,
                                  VALUE      => I_VALUE
                                );
    END;

END;
/


Prompt *****************************************************************
Prompt **                        T A B L E S                          **
Prompt *****************************************************************




/*============================================================================================*/
CREATE TABLE ML_LANGUAGES (
/*============================================================================================*/
    ID                      NUMBER   (     10 )
        CONSTRAINT ML_LANGUAGES_ID_NN              NOT NULL,
        CONSTRAINT ML_LANGUAGES_PK                 PRIMARY KEY ( ID ) USING INDEX ( CREATE UNIQUE INDEX ML_LANGUAGES_PK ON ML_LANGUAGES ( ID ) ),
    CODE                    VARCHAR2 (      3 )
        CONSTRAINT ML_LANGUAGES_CODE_NN            NOT NULL,
        CONSTRAINT ML_LANGUAGES_CODE_UN            UNIQUE ( CODE ) USING INDEX ( CREATE UNIQUE INDEX ML_LANGUAGES_IDX1 ON ML_LANGUAGES ( CODE ) ),
    TEXT                    NVARCHAR2(    100 )
        CONSTRAINT ML_LANGUAGES_TEXT_NN            NOT NULL,      
    IS_DEFAULT              CHAR     ( 1 BYTE ) DEFAULT 'N'
        CONSTRAINT ML_LANGUAGES_IS_DEFAULT_NN      NOT NULL,      
        CONSTRAINT ML_LANGUAGES_IS_DEFAULT_CH      CHECK ( IS_DEFAULT IN ( 'Y', 'N' ) )
  );

COMMENT ON TABLE  ML_LANGUAGES                 IS 'List of the possible ML_LANGUAGES';
COMMENT ON COLUMN ML_LANGUAGES.ID              IS 'Internal ID, Primary key';
COMMENT ON COLUMN ML_LANGUAGES.CODE            IS 'ISO 639 code of the language';
COMMENT ON COLUMN ML_LANGUAGES.TEXT            IS 'The name of the language';
COMMENT ON COLUMN ML_LANGUAGES.IS_DEFAULT      IS 'Y=this is the default, N=this is not the default language. There must be excatly 1 default!';


/*============================================================================================*/
CREATE OR REPLACE TRIGGER TR_ML_LANGUAGES_BIUR
/*============================================================================================*/
    BEFORE INSERT OR UPDATE ON ML_LANGUAGES FOR EACH ROW
BEGIN
    :NEW.ID         := NVL( :NEW.ID, ML_SEQ_ID.NEXTVAL );
    :NEW.CODE       := UPPER( :NEW.CODE );
    :NEW.IS_DEFAULT := UPPER( :NEW.IS_DEFAULT );
END;
/


/*============================================================================================*/
CREATE TABLE ML_NLS_PARAMETERS (
/*============================================================================================*/
    ID                      NUMBER   (     10 )
        CONSTRAINT ML_NLS_PARAMETERS_ID_NN         NOT NULL,
        CONSTRAINT ML_NLS_PARAMETERS_PK            PRIMARY KEY ( ID ) USING INDEX ( CREATE UNIQUE INDEX ML_NLS_PARAMETERS_PK ON ML_NLS_PARAMETERS ( ID ) ),
    CODE                    VARCHAR2 (     50 )
        CONSTRAINT ML_NLS_PARAMETERS_CODE_NN       NOT NULL,
        CONSTRAINT ML_NLS_PARAMETERS_CODE_UN       UNIQUE ( CODE ) USING INDEX ( CREATE UNIQUE INDEX ML_NLS_PARAMETERS_IDX1 ON ML_NLS_PARAMETERS ( CODE ) ),
    TEXT                    NVARCHAR2(    100 )
  );

COMMENT ON TABLE  ML_NLS_PARAMETERS                 IS 'List of the NLS parameters';
COMMENT ON COLUMN ML_NLS_PARAMETERS.ID              IS 'Internal ID, Primary key';
COMMENT ON COLUMN ML_NLS_PARAMETERS.CODE            IS 'Oracle code of the NLS parameter, will use for alter session';
COMMENT ON COLUMN ML_NLS_PARAMETERS.TEXT            IS 'The meaning of the parameter';

/*============================================================================================*/
CREATE OR REPLACE TRIGGER TR_ML_NLS_PARAMETERS_BIUR
/*============================================================================================*/
    BEFORE INSERT OR UPDATE ON ML_NLS_PARAMETERS FOR EACH ROW
BEGIN
    :NEW.ID         := NVL( :NEW.ID, ML_SEQ_ID.NEXTVAL );
    :NEW.CODE       := UPPER( :NEW.CODE );
END;
/

INSERT INTO ML_NLS_PARAMETERS ( ID, CODE, TEXT ) VALUES (  1, 'NLS_COMP'                   , 'SQL Operator comparison'               );                
INSERT INTO ML_NLS_PARAMETERS ( ID, CODE, TEXT ) VALUES (  2, 'NLS_SORT'                   , 'Character Sort Sequence'               );
INSERT INTO ML_NLS_PARAMETERS ( ID, CODE, TEXT ) VALUES (  3, 'NLS_CALENDAR'               , 'Calendar system'                       );
INSERT INTO ML_NLS_PARAMETERS ( ID, CODE, TEXT ) VALUES (  4, 'NLS_LANGUAGE'               , 'Language'                              );
INSERT INTO ML_NLS_PARAMETERS ( ID, CODE, TEXT ) VALUES (  5, 'NLS_TERRITORY'              , 'Territory'                             );
INSERT INTO ML_NLS_PARAMETERS ( ID, CODE, TEXT ) VALUES (  6, 'NLS_DATE_FORMAT'            , 'Date format'                           );
INSERT INTO ML_NLS_PARAMETERS ( ID, CODE, TEXT ) VALUES (  7, 'NLS_TIME_FORMAT'            , 'Time format'                           );         
INSERT INTO ML_NLS_PARAMETERS ( ID, CODE, TEXT ) VALUES (  8, 'NLS_TIMESTAMP_FORMAT'       , 'Timestamp format'                      );
INSERT INTO ML_NLS_PARAMETERS ( ID, CODE, TEXT ) VALUES (  9, 'NLS_TIMESTAMP_TZ_FORMAT'    , 'Timestamp with timezone format'        ); 
INSERT INTO ML_NLS_PARAMETERS ( ID, CODE, TEXT ) VALUES ( 10, 'NLS_DATE_LANGUAGE'          , 'Language for day and month names'      );
INSERT INTO ML_NLS_PARAMETERS ( ID, CODE, TEXT ) VALUES ( 11, 'NLS_CURRENCY'               , 'Local currency symbol'                 );
INSERT INTO ML_NLS_PARAMETERS ( ID, CODE, TEXT ) VALUES ( 12, 'NLS_ISO_CURRENCY'           , 'ISO international currency symbol'     );
INSERT INTO ML_NLS_PARAMETERS ( ID, CODE, TEXT ) VALUES ( 13, 'NLS_DUAL_CURRENCY'          , 'Dual currency symbol'                  );
INSERT INTO ML_NLS_PARAMETERS ( ID, CODE, TEXT ) VALUES ( 14, 'NLS_NUMERIC_CHARACTERS'     , 'Decimal character and group separator' );


/*============================================================================================*/
CREATE TABLE ML_NLS_SETTINGS (
/*============================================================================================*/
    ID                      NUMBER   (     10 )
        CONSTRAINT ML_NLS_SETTINGS_ID_NN         NOT NULL,
        CONSTRAINT ML_NLS_SETTINGS_PK            PRIMARY KEY ( ID ) USING INDEX ( CREATE UNIQUE INDEX ML_NLS_SETTINGS_PK ON ML_NLS_SETTINGS ( ID ) ),
    LANGUAGE_ID             NUMBER   (     10 )
        CONSTRAINT ML_NLS_SETTINGS_LANG_ID_NN    NOT NULL,
        CONSTRAINT ML_NLS_SETTINGS_FK1           FOREIGN KEY ( LANGUAGE_ID ) REFERENCES ML_LANGUAGES ( ID ),
    NLS_PARAMETER_ID        NUMBER   (     10 )
        CONSTRAINT ML_NLS_SETTINGS_NLS_PRM_ID_NN NOT NULL,
        CONSTRAINT ML_NLS_SETTINGS_FK2           FOREIGN KEY ( NLS_PARAMETER_ID ) REFERENCES ML_NLS_PARAMETERS ( ID ),
        CONSTRAINT ML_NLS_SETTINGS_UN            UNIQUE ( LANGUAGE_ID, NLS_PARAMETER_ID ) USING INDEX ( CREATE UNIQUE INDEX ML_NLS_SETTINGS_IDX1 ON ML_NLS_SETTINGS ( LANGUAGE_ID, NLS_PARAMETER_ID ) ),
    SETTING                 VARCHAR2 (    500 )
        CONSTRAINT ML_NLS_SETTINGS_SETTING_NN NOT NULL
  );

COMMENT ON TABLE  ML_NLS_SETTINGS                   IS 'NLS setting values to ML_LANGUAGES';
COMMENT ON COLUMN ML_NLS_SETTINGS.ID                IS 'Internal ID, Primary key';
COMMENT ON COLUMN ML_NLS_SETTINGS.LANGUAGE_ID       IS 'To this language';
COMMENT ON COLUMN ML_NLS_SETTINGS.NLS_PARAMETER_ID  IS 'This parameter';
COMMENT ON COLUMN ML_NLS_SETTINGS.SETTING           IS 'Value is this';

/*============================================================================================*/
CREATE OR REPLACE TRIGGER TR_ML_NLS_SETTINGS_BIUR
/*============================================================================================*/
    BEFORE INSERT OR UPDATE ON ML_NLS_SETTINGS FOR EACH ROW
BEGIN
    :NEW.ID         := NVL( :NEW.ID, ML_SEQ_ID.NEXTVAL );
END;
/


/*============================================================================================*/
CREATE TABLE ML_SCHEMAS (
/*============================================================================================*/
    ID                      NUMBER              
        CONSTRAINT ML_SCHEMAS_ID_NN              NOT NULL,
        CONSTRAINT ML_SCHEMAS_PK                 PRIMARY KEY ( ID ) USING INDEX ( CREATE UNIQUE INDEX ML_SCHEMAS_PK ON ML_SCHEMAS ( ID ) ),
    NAME                    VARCHAR2(  200 )    
        CONSTRAINT ML_SCHEMAS_NAME_NN            NOT NULL,
        CONSTRAINT ML_SCHEMAS_NAME_UN            UNIQUE      ( NAME ) USING INDEX ( CREATE UNIQUE INDEX ML_SCHEMAS_IDX1 ON ML_SCHEMAS ( NAME ) )
  );

/*============================================================================================*/
CREATE OR REPLACE TRIGGER TR_ML_SCHEMAS_BIUR
/*============================================================================================*/
    BEFORE INSERT OR UPDATE ON ML_SCHEMAS FOR EACH ROW
BEGIN
    :NEW.ID         := NVL( :NEW.ID, ML_SEQ_ID.NEXTVAL );
    :NEW.NAME       := UPPER( :NEW.NAME );
END;
/


/*============================================================================================*/
CREATE TABLE ML_TABLES (
/*============================================================================================*/
    ID                      NUMBER              
        CONSTRAINT ML_TABLES_ID_NN              NOT NULL,
        CONSTRAINT ML_TABLES_PK                 PRIMARY KEY ( ID ) USING INDEX ( CREATE UNIQUE INDEX ML_TABLES_PK ON ML_TABLES ( ID ) ),
    SCHEMA_ID               NUMBER              
        CONSTRAINT ML_TABLES_SCHEMA_ID_NN       NOT NULL,
        CONSTRAINT ML_TABLES_FK1                FOREIGN KEY ( SCHEMA_ID ) REFERENCES ML_SCHEMAS ( ID ) ,
    NAME                    VARCHAR2(  200 )    
        CONSTRAINT ML_TABLES_NAME_NN            NOT NULL,
        CONSTRAINT ML_TABLES_NAME_UN            UNIQUE      ( SCHEMA_ID, NAME ) USING INDEX ( CREATE UNIQUE INDEX ML_TABLES_IDX1 ON ML_TABLES ( SCHEMA_ID, NAME ) )
  );

/*============================================================================================*/
CREATE OR REPLACE TRIGGER TR_ML_TABLES_BIUR
/*============================================================================================*/
    BEFORE INSERT OR UPDATE ON ML_TABLES FOR EACH ROW
DECLARE
    V_ID    NUMBER ( 10 );
BEGIN
    :NEW.ID         := NVL( :NEW.ID       , ML_SEQ_ID.NEXTVAL );
    IF :NEW.SCHEMA_ID IS NULL THEN
        SELECT MAX( ID ) INTO V_ID FROM ML_SCHEMAS;
        :NEW.SCHEMA_ID  := V_ID;
    END IF;
    :NEW.NAME       := UPPER( :NEW.NAME );
END;
/


/*============================================================================================*/
CREATE TABLE ML_COLUMNS (
/*============================================================================================*/
    ID                      NUMBER              
        CONSTRAINT ML_COLUMNS_ID_NN              NOT NULL,
        CONSTRAINT ML_COLUMNS_PK                 PRIMARY KEY ( ID ) USING INDEX ( CREATE UNIQUE INDEX ML_COLUMNS_PK ON ML_COLUMNS ( ID ) ),
    TABLE_ID                NUMBER              
        CONSTRAINT ML_COLUMNS_TABLE_ID_NN        NOT NULL,
        CONSTRAINT ML_COLUMNS_FK1                FOREIGN KEY ( TABLE_ID ) REFERENCES ML_TABLES ( ID ) ,
    NAME                    VARCHAR2(  200 )    
        CONSTRAINT ML_COLUMNS_NAME_NN            NOT NULL,
        CONSTRAINT ML_COLUMNS_NAME_UN            UNIQUE      ( TABLE_ID, NAME ) USING INDEX ( CREATE UNIQUE INDEX ML_COLUMNS_IDX1 ON ML_COLUMNS ( TABLE_ID, NAME ) )
  );

/*============================================================================================*/
CREATE OR REPLACE TRIGGER TR_ML_COLUMNS_BIUR
/*============================================================================================*/
    BEFORE INSERT OR UPDATE ON ML_COLUMNS FOR EACH ROW
DECLARE
    V_ID    NUMBER ( 10 );
BEGIN
    :NEW.ID         := NVL( :NEW.ID, ML_SEQ_ID.NEXTVAL );
    IF :NEW.TABLE_ID IS NULL THEN
        SELECT MAX( ID ) INTO V_ID FROM ML_TABLES;
        :NEW.TABLE_ID  := V_ID;
    END IF;
    :NEW.NAME       := UPPER( :NEW.NAME );
END;
/


/*============================================================================================*/
CREATE TABLE ML_TRANSLATIONS (
/*============================================================================================*/
    ID                      NUMBER   (   10 )     
        CONSTRAINT ML_TRANSLATIONS_ID_NN             NOT NULL,
        CONSTRAINT ML_TRANSLATIONS_PK                PRIMARY KEY ( ID ) USING INDEX ( CREATE UNIQUE INDEX ML_TRANSLATIONS_PK ON ML_TRANSLATIONS ( ID ) ),
    LANGUAGE_ID             NUMBER   (   10 )     
        CONSTRAINT ML_TRANSLATIONS_LANG_ID_NN        NOT NULL,
        CONSTRAINT ML_TRANSLATIONS_FK1               FOREIGN KEY ( LANGUAGE_ID ) REFERENCES ML_LANGUAGES ( ID ) ,
    COLUMN_ID               NUMBER   (   10 )     
        CONSTRAINT ML_TRANSLATIONS_COLUMN_ID_NN      NOT NULL,
        CONSTRAINT ML_TRANSLATIONS_FK2               FOREIGN KEY ( COLUMN_ID ) REFERENCES ML_COLUMNS ( ID ) ,
    ROW_PK                  NVARCHAR2( 2000 )
        CONSTRAINT ML_TRANSLATIONS_ROW_PK_NN         NOT NULL,
        CONSTRAINT ML_TRANSLATIONS_UN  UNIQUE ( LANGUAGE_ID, COLUMN_ID, ROW_PK ) 
            USING INDEX ( CREATE UNIQUE INDEX ML_TRANSLATIONS_IDX1 ON ML_TRANSLATIONS ( LANGUAGE_ID, COLUMN_ID, ROW_PK ) ),
    TEXT                    NVARCHAR2( 2000 )
        CONSTRAINT ML_TRANSLATIONS_TEXT_NN           NOT NULL
    );

/*============================================================================================*/
CREATE OR REPLACE TRIGGER TR_ML_TRANSLATIONS_BIUR
/*============================================================================================*/
    BEFORE INSERT OR UPDATE ON ML_TRANSLATIONS FOR EACH ROW
BEGIN
    :NEW.ID         := NVL( :NEW.ID, ML_SEQ_ID.NEXTVAL );
END;
/



Prompt *****************************************************************
Prompt **                         V I E W S                           **
Prompt *****************************************************************

/*============================================================================================*/
CREATE OR REPLACE VIEW ML_LANGUAGES_VW AS
/*============================================================================================*/
SELECT *
  FROM ML_LANGUAGES;


/*============================================================================================*/
CREATE OR REPLACE VIEW ML_NLS_PARAMETERS_VW AS
/*============================================================================================*/
SELECT *
  FROM ML_NLS_PARAMETERS;


/*============================================================================================*/
CREATE OR REPLACE VIEW ML_NLS_SETTINGS_VW AS
/*============================================================================================*/
SELECT ID
     , LANGUAGE_ID
     , ( SELECT CODE FROM ML_LANGUAGES      WHERE ID = LANGUAGE_ID      )  AS LANGUAGE_CODE
     , NLS_PARAMETER_ID
     , ( SELECT CODE FROM ML_NLS_PARAMETERS WHERE ID = NLS_PARAMETER_ID )  AS NLS_PARAMETER_CODE
     , SETTING
  FROM ML_NLS_SETTINGS;


/*============================================================================================*/
CREATE OR REPLACE VIEW ML_SCHEMAS_VW AS
/*============================================================================================*/
SELECT *
  FROM ML_SCHEMAS;


/*============================================================================================*/
CREATE OR REPLACE VIEW ML_TABLES_VW AS
/*============================================================================================*/
SELECT ID 
     , SCHEMA_ID
     , ( SELECT NAME FROM ML_SCHEMAS WHERE ID = SCHEMA_ID )  AS SCHEMA_NAME
     , NAME  
  FROM ML_TABLES;


/*============================================================================================*/
CREATE OR REPLACE VIEW ML_COLUMNS_VW AS
/*============================================================================================*/
SELECT ML_COLUMNS.ID
     , ML_TABLES_VW.SCHEMA_ID
     , ML_TABLES_VW.SCHEMA_NAME
     , TABLE_ID              
     , ML_TABLES_VW.NAME  AS TABLE_NAME
     , ML_COLUMNS.NAME                  
  FROM ML_COLUMNS
     , ML_TABLES_VW
 WHERE ML_COLUMNS.TABLE_ID = ML_TABLES_VW.ID;


/*============================================================================================*/
CREATE OR REPLACE VIEW ML_TRANSLATIONS_VW AS
/*============================================================================================*/
SELECT ML_TRANSLATIONS.ID
     , LANGUAGE_ID
     , ( SELECT CODE FROM ML_LANGUAGES      WHERE ID = LANGUAGE_ID      )  AS LANGUAGE_CODE
     , ML_COLUMNS_VW.ID   AS COLUMN_ID
     , ML_COLUMNS_VW.SCHEMA_ID
     , ML_COLUMNS_VW.SCHEMA_NAME
     , ML_COLUMNS_VW.TABLE_ID              
     , ML_COLUMNS_VW.TABLE_NAME
     , ML_COLUMNS_VW.NAME   AS COLUMN_NAME
     , ROW_PK
     , TEXT
  FROM ML_TRANSLATIONS
     , ML_COLUMNS_VW
 WHERE ML_TRANSLATIONS.COLUMN_ID = ML_COLUMNS_VW.ID;


/*************************************/
Prompt   P A C K A G E   H E A D E R
/*************************************/

/*============================================================================================*/
create or replace package PKG_MLM is
/*============================================================================================*/
/*  HISTORY OF CHANGES
    YYYY.MM.DD  VERSION AUTHOR         CHANGES
    2014.06.01  1.0     F. TOTH        CREATED    
*/

    NUMBER_OF_ML_LANGUAGES         integer;
    LANGUAGE_ID                     number  ( 10 );
    LANGUAGE_CODE                   varchar2(  3 );
    DEFAULT_LANGUAGE_ID             number  ( 10 );
    DEFAULT_LANGUAGE_CODE           varchar2(  3 );
    DUMMY_TEXT                      varchar2( 10 ) := chr( 1 );

    ------------------------------------------------------------------------------------
    function  GET_DEFAULT_LANGUAGE_ID   return number;
    ------------------------------------------------------------------------------------
    function  GET_DEFAULT_LANGUAGE_CODE return varchar2;
    ------------------------------------------------------------------------------------
    procedure SET_LANGUAGE  ( I_LANGUAGE_ID   in number   := LANGUAGE_ID   );
    ------------------------------------------------------------------------------------
    procedure SET_LANGUAGE  ( I_LANGUAGE_CODE in varchar2 := LANGUAGE_CODE );
    ------------------------------------------------------------------------------------
    function  GET_LANGUAGE_ID   return number;
    ------------------------------------------------------------------------------------
    function  GET_LANGUAGE_CODE return varchar2;
    ------------------------------------------------------------------------------------
    function  GET_COLUMN_ID ( I_SCHEMA_NAME         in varchar2,
                              I_TABLE_NAME          in varchar2,
                              I_COLUMN_NAME         in varchar2
                            ) return nvarchar2;
    ------------------------------------------------------------------------------------
    function  GET_TRANSLATION(  I_LANGUAGE_ID        in number,
                                I_COLUMN_ID          in number,
                                I_ROW_PK             in nvarchar2
                             )  return nvarchar2;
    ------------------------------------------------------------------------------------
    function  GET_TEXT ( I_LANGUAGE_ID         in number,
                         I_COLUMN_ID           in number,
                         I_ROW_PK              in nvarchar2, 
                         I_TEXT                in nvarchar2 := DUMMY_TEXT
                       ) return nvarchar2;
    ------------------------------------------------------------------------------------
    function  GET_TEXT_LANG ( I_LANGUAGE_CODE       in varchar2,
                              I_SCHEMA_NAME         in varchar2,
                              I_TABLE_NAME          in varchar2,
                              I_COLUMN_NAME         in varchar2,
                              I_ROW_PK              in nvarchar2, 
                              I_TEXT                in nvarchar2 := DUMMY_TEXT
                            ) return nvarchar2;
    ------------------------------------------------------------------------------------
    function  GET_TEXT ( I_SCHEMA_NAME         in varchar2,
                         I_TABLE_NAME          in varchar2,
                         I_COLUMN_NAME         in varchar2,
                         I_ROW_PK              in nvarchar2, 
                         I_TEXT                in nvarchar2 := DUMMY_TEXT
                       ) return nvarchar2;
    ------------------------------------------------------------------------------------
    procedure ADD_TRANSLATION ( I_LANGUAGE_ID         in number,
                                I_COLUMN_ID           in number,
                                I_ROW_PK              in nvarchar2, 
                                I_TEXT                in nvarchar2
                               );
    ------------------------------------------------------------------------------------
    procedure ADD_TRANSLATION ( I_LANGUAGE_CODE       in varchar2,
                                I_SCHEMA_NAME         in varchar2,
                                I_TABLE_NAME          in varchar2,
                                I_COLUMN_NAME         in varchar2,
                                I_ROW_PK              in nvarchar2, 
                                I_TEXT                in nvarchar2
                              );
    ------------------------------------------------------------------------------------
    procedure ADD_TRANSLATION ( I_SCHEMA_NAME         in varchar2,
                                I_TABLE_NAME          in varchar2,
                                I_COLUMN_NAME         in varchar2,
                                I_ROW_PK              in nvarchar2, 
                                I_TEXT                in nvarchar2
                              );
    ------------------------------------------------------------------------------------
    procedure SET_GLOBALS;
    ------------------------------------------------------------------------------------
    procedure GET_GLOBALS;
    ------------------------------------------------------------------------------------
    procedure  WRITE_TRANSLATION_FILE( I_LANGUAGE_CODE  in varchar2 := null, 
                                       I_ONLY_MISSING   in char     := null,   -- 'Y' = write out only what is missing from ML_TRANSLATIONS
                                       I_DIRECTORY      in varchar2 := null,
                                       I_FILE_NAME      in varchar2 := null
                                      );
    ------------------------------------------------------------------------------------

end PKG_MLM;
/


/*************************************/
Prompt   P A C K A G E   B O D Y 
/*************************************/

/*============================================================================================*/
create or replace package body PKG_MLM is
/*============================================================================================*/
/*  HISTORY OF CHANGES
    YYYY.MM.DD  VERSION AUTHOR         CHANGES
    2014.06.01  1.0     F. TOTH        CREATED    
*/

    ------------------------------------------------------------------------------------
    function  GET_DEFAULT_LANGUAGE_ID   return number is
    ------------------------------------------------------------------------------------
    begin
        return DEFAULT_LANGUAGE_ID;
    end;


    ------------------------------------------------------------------------------------
    function  GET_DEFAULT_LANGUAGE_CODE return varchar2 is
    ------------------------------------------------------------------------------------
    begin
        return DEFAULT_LANGUAGE_CODE;
    end;


    ------------------------------------------------------------------------------------
    procedure SET_LANGUAGE  ( I_LANGUAGE_ID   in number   := LANGUAGE_ID   ) is
    ------------------------------------------------------------------------------------
    begin
        SET_GLOBALS;
        LANGUAGE_ID := I_LANGUAGE_ID;
        select CODE into LANGUAGE_CODE from ML_LANGUAGES where ID = I_LANGUAGE_ID; 
        for L_R in ( select * from ML_NLS_SETTINGS_VW where ML_NLS_SETTINGS_VW.LANGUAGE_ID = I_LANGUAGE_ID ) 
        loop
            -- dbms_output.put_line( 'alter session set '||L_R.NLS_PARAMETER_CODE||' = '''||L_R.SETTING||'''');
            execute immediate 'alter session set '||L_R.NLS_PARAMETER_CODE||' = '''||L_R.SETTING||'''';
        end loop;
    end;


    ------------------------------------------------------------------------------------
    procedure SET_LANGUAGE  ( I_LANGUAGE_CODE in varchar2 := LANGUAGE_CODE ) is
    ------------------------------------------------------------------------------------
        V_LANGUAGE_ID       number ( 10 );
    begin
        select min( ID ) into V_LANGUAGE_ID from ML_LANGUAGES where CODE = upper( I_LANGUAGE_CODE ); 
        SET_LANGUAGE( V_LANGUAGE_ID ); 
    end;


    ------------------------------------------------------------------------------------
    function  GET_LANGUAGE_ID   return number is
    ------------------------------------------------------------------------------------
    begin
        return LANGUAGE_ID;
    end;


    ------------------------------------------------------------------------------------
    function  GET_LANGUAGE_CODE return varchar2 is
    ------------------------------------------------------------------------------------
    begin
        return LANGUAGE_CODE;
    end;


    ------------------------------------------------------------------------------------
    function  GET_COLUMN_ID ( I_SCHEMA_NAME         in varchar2,
                              I_TABLE_NAME          in varchar2,
                              I_COLUMN_NAME         in varchar2
                            ) return nvarchar2 is
    ------------------------------------------------------------------------------------
        V_COLUMN_ID       number ( 10 );
    begin
        select min( ID ) into V_COLUMN_ID from ML_COLUMNS_VW 
         where SCHEMA_NAME = upper( I_SCHEMA_NAME ) and TABLE_NAME = upper( I_TABLE_NAME ) and NAME = upper( I_COLUMN_NAME ); 
        return V_COLUMN_ID; 
    end;


    ------------------------------------------------------------------------------------
    function  GET_TRANSLATION(  I_LANGUAGE_ID        in number,
                                I_COLUMN_ID          in number,
                                I_ROW_PK             in nvarchar2
                             )  return nvarchar2 is
    ------------------------------------------------------------------------------------
        V_TEXT      ML_TRANSLATIONS.TEXT%type;
    begin  
        select min( TEXT ) into V_TEXT from ML_TRANSLATIONS where LANGUAGE_ID = I_LANGUAGE_ID and COLUMN_ID = I_COLUMN_ID and ROW_PK = I_ROW_PK;
        return V_TEXT; 
    end;


    ------------------------------------------------------------------------------------
    function  GET_TEXT ( I_LANGUAGE_ID         in number,
                         I_COLUMN_ID           in number,
                         I_ROW_PK              in nvarchar2, 
                         I_TEXT                in nvarchar2 := DUMMY_TEXT
                       ) return nvarchar2 is
    ------------------------------------------------------------------------------------
    begin
        if I_TEXT is null then
            return null;
        end if;
        GET_GLOBALS;
        if ( NUMBER_OF_ML_LANGUAGES = 1 or LANGUAGE_ID = DEFAULT_LANGUAGE_ID ) and I_TEXT != DUMMY_TEXT then
            return I_TEXT;
        else
            return GET_TRANSLATION( I_LANGUAGE_ID, I_COLUMN_ID, I_ROW_PK );
        end if;
    end;


    ------------------------------------------------------------------------------------
    function  GET_TEXT_LANG ( I_LANGUAGE_CODE       in varchar2,
                              I_SCHEMA_NAME         in varchar2,
                              I_TABLE_NAME          in varchar2,
                              I_COLUMN_NAME         in varchar2,
                              I_ROW_PK              in nvarchar2, 
                              I_TEXT                in nvarchar2 := DUMMY_TEXT
                            ) return nvarchar2 is
    ------------------------------------------------------------------------------------
        V_LANGUAGE_ID       number ( 10 );
        V_COLUMN_ID         number ( 10 );
    begin
        if I_TEXT is null then
            return null;
        end if;
        GET_GLOBALS;
        if ( NUMBER_OF_ML_LANGUAGES = 1 or LANGUAGE_ID = DEFAULT_LANGUAGE_ID ) and I_TEXT != DUMMY_TEXT then
            return I_TEXT;
        else
            select min( ID ) into V_LANGUAGE_ID from ML_LANGUAGES where CODE = upper( I_LANGUAGE_CODE ); 
            V_COLUMN_ID := GET_COLUMN_ID ( I_SCHEMA_NAME, I_TABLE_NAME, I_COLUMN_NAME );
            return GET_TEXT( V_LANGUAGE_ID, V_COLUMN_ID, I_ROW_PK, I_TEXT );
        end if;
    end;


    ------------------------------------------------------------------------------------
    function  GET_TEXT ( I_SCHEMA_NAME         in varchar2,
                         I_TABLE_NAME          in varchar2,
                         I_COLUMN_NAME         in varchar2,
                         I_ROW_PK              in nvarchar2, 
                         I_TEXT                in nvarchar2 := DUMMY_TEXT
                       ) return nvarchar2 is
    ------------------------------------------------------------------------------------
    begin
        if I_TEXT is null then
            return null;
        end if;
        GET_GLOBALS;
        if ( NUMBER_OF_ML_LANGUAGES = 1 or LANGUAGE_ID = DEFAULT_LANGUAGE_ID ) and I_TEXT != DUMMY_TEXT then
            return I_TEXT;
        else
            return GET_TEXT_LANG( LANGUAGE_CODE, I_SCHEMA_NAME, I_TABLE_NAME, I_COLUMN_NAME, I_ROW_PK, I_TEXT );
        end if;
    end;


    ------------------------------------------------------------------------------------
    procedure ADD_TRANSLATION ( I_LANGUAGE_ID         in number,
                                I_COLUMN_ID           in number,
                                I_ROW_PK              in nvarchar2, 
                                I_TEXT                in nvarchar2
                              ) is
    ------------------------------------------------------------------------------------
    begin
        insert into ML_TRANSLATIONS ( LANGUAGE_ID, COLUMN_ID, ROW_PK, TEXT ) values ( I_LANGUAGE_ID, I_COLUMN_ID, I_ROW_PK, I_TEXT );
    exception when DUP_VAL_ON_INDEX then
        update ML_TRANSLATIONS set TEXT = I_TEXT where LANGUAGE_ID = I_LANGUAGE_ID and COLUMN_ID = I_COLUMN_ID and ROW_PK = I_ROW_PK;
    end;


    ------------------------------------------------------------------------------------
    procedure ADD_TRANSLATION ( I_LANGUAGE_CODE       in varchar2,
                                I_SCHEMA_NAME         in varchar2,
                                I_TABLE_NAME          in varchar2,
                                I_COLUMN_NAME         in varchar2,
                                I_ROW_PK              in nvarchar2, 
                                I_TEXT                in nvarchar2
                              ) is
    ------------------------------------------------------------------------------------
        V_LANGUAGE_ID       number ( 10 );
        V_COLUMN_ID         number ( 10 );
    begin
        if I_TEXT is not null then
            select min( ID ) into V_LANGUAGE_ID from ML_LANGUAGES where CODE = upper( I_LANGUAGE_CODE ); 
            V_COLUMN_ID := GET_COLUMN_ID ( I_SCHEMA_NAME, I_TABLE_NAME, I_COLUMN_NAME );
            ADD_TRANSLATION( V_LANGUAGE_ID, V_COLUMN_ID, I_ROW_PK, I_TEXT );
        end if;
    end;


    ------------------------------------------------------------------------------------
    procedure ADD_TRANSLATION ( I_SCHEMA_NAME         in varchar2,
                                I_TABLE_NAME          in varchar2,
                                I_COLUMN_NAME         in varchar2,
                                I_ROW_PK              in nvarchar2, 
                                I_TEXT                in nvarchar2
                              ) is
    ------------------------------------------------------------------------------------
    begin
        if I_TEXT is not null then
            ADD_TRANSLATION( LANGUAGE_CODE, I_SCHEMA_NAME, I_TABLE_NAME, I_COLUMN_NAME, I_ROW_PK, I_TEXT );
        end if;
    end;


    ------------------------------------------------------------------------------------
    procedure SET_GLOBALS is
    ------------------------------------------------------------------------------------
    begin

        select count( * )  into NUMBER_OF_ML_LANGUAGES   from ML_LANGUAGES;
        ML_CONTEXT.SET_CONTEXT( 'NUMBER_OF_ML_LANGUAGES', NUMBER_OF_ML_LANGUAGES );

        select min( ID )   into DEFAULT_LANGUAGE_ID   from ML_LANGUAGES where IS_DEFAULT = 'Y'; 
        ML_CONTEXT.SET_CONTEXT( 'DEFAULT_LANGUAGE_ID', DEFAULT_LANGUAGE_ID );

        select min( CODE ) into DEFAULT_LANGUAGE_CODE from ML_LANGUAGES where ID         = DEFAULT_LANGUAGE_ID; 
        ML_CONTEXT.SET_CONTEXT( 'DEFAULT_LANGUAGE_CODE', DEFAULT_LANGUAGE_CODE );

    end;


    ------------------------------------------------------------------------------------
    procedure GET_GLOBALS is
    ------------------------------------------------------------------------------------
    begin
        NUMBER_OF_ML_LANGUAGES  := SYS_CONTEXT( 'MLM', 'NUMBER_OF_ML_LANGUAGES'   );
        DEFAULT_LANGUAGE_ID     := SYS_CONTEXT( 'MLM', 'DEFAULT_LANGUAGE_ID'   );
        DEFAULT_LANGUAGE_CODE   := SYS_CONTEXT( 'MLM', 'DEFAULT_LANGUAGE_CODE' );
    end;



    ------------------------------------------------------------------------------------
    procedure  WRITE_TRANSLATION_FILE( I_LANGUAGE_CODE  in varchar2 := null, 
                                       I_ONLY_MISSING   in char     := null,   -- 'Y' = write out only what is missing from ML_TRANSLATIONS
                                       I_DIRECTORY      in varchar2 := null,
                                       I_FILE_NAME      in varchar2 := null
                                     ) is
    ------------------------------------------------------------------------------------
        K_EOL                varchar2 (    10 ) := chr( 13 ) || chr( 10 );
        L_FILE               utl_file.file_type;
        L_FILE_NAME          varchar2 (   400 );
        L_LINE               nvarchar2( 16000 );
        L_TEXT               nvarchar2( 16000 );
        L_ID                 number   (    10 );
        L_SQL                varchar2 ( 32000 );
        L_PK                 varchar2 (    40 );
        L_PREV_TABLE_ID      integer := 0;
        L_COL_REC            sys_refcursor;
        L_REC_SET            sys_refcursor;
    begin
        if I_LANGUAGE_CODE is null or I_LANGUAGE_CODE != DEFAULT_LANGUAGE_CODE then

            for L_LANG_REC in ( select * from ML_LANGUAGES where CODE = nvl( I_LANGUAGE_CODE, CODE ) and CODE != DEFAULT_LANGUAGE_CODE )
            loop

                L_FILE_NAME := nvl( I_FILE_NAME, 'translation_for_'|| L_LANG_REC.CODE || '_' || to_char(sysdate,'yyyymmddhh24miss') );
                if I_DIRECTORY is not null then
                    L_FILE  := UTL_FILE.FOPEN( nvl( I_DIRECTORY, 'DATA_FILE_DIR' ), L_FILE_NAME ||'.TMP', 'W');
                else
                    DBMS_OUTPUT.ENABLE( null );
                end if;

                L_LINE := 'PROMPT *****************************************************************';
                if I_DIRECTORY is not null then
                    utl_file.put_line( L_FILE, L_LINE , true );
                else
                    dbms_output.put_line( L_LINE );
                end if;

                L_LINE := 'PROMPT **            T R A N S L A T I O N S     '||L_LANG_REC.CODE||'                  **';
                if I_DIRECTORY is not null then
                    utl_file.put_line( L_FILE, L_LINE , true );
                else
                    dbms_output.put_line( L_LINE );
                end if;

                L_LINE := 'PROMPT *****************************************************************';
                if I_DIRECTORY is not null then
                    utl_file.put_line( L_FILE, L_LINE , true );
                else
                    dbms_output.put_line( L_LINE );
                end if;

                for L_COL_REC in (select * 
                                    from ML_COLUMNS_VW 
                                   order by SCHEMA_NAME, TABLE_NAME, ID
                                 )
                loop

                    if L_PREV_TABLE_ID <> L_COL_REC.TABLE_ID then

                        -- HEADER
                        L_LINE := '/*************************************/';
                        if I_DIRECTORY is not null then
                            utl_file.put_line( L_FILE, L_LINE , true );
                        else
                            dbms_output.put_line( L_LINE );
                        end if;
                     
                        L_LINE := 'PROMPT   '||L_COL_REC.TABLE_NAME;
                        if I_DIRECTORY is not null then
                            utl_file.put_line( L_FILE, L_LINE , true );
                        else
                            dbms_output.put_line( L_LINE );
                        end if;

                        L_LINE := '/*************************************/';
                        if I_DIRECTORY is not null then
                            utl_file.put_line( L_FILE, L_LINE , true );
                        else
                            dbms_output.put_line( L_LINE );
                        end if;

                        L_PREV_TABLE_ID := L_COL_REC.TABLE_ID;

                        select COLUMN_NAME
                          into L_PK
                          from ALL_CONSTRAINTS UC, ALL_CONS_COLUMNS DBC
                         where UC.CONSTRAINT_TYPE  = 'P'
                           and DBC.CONSTRAINT_NAME = UC.CONSTRAINT_NAME
                           and DBC.OWNER           = L_COL_REC.SCHEMA_NAME
                           and UC.OWNER            = L_COL_REC.SCHEMA_NAME
                           and DBC.TABLE_NAME      = L_COL_REC.TABLE_NAME;

                    end if;

                    L_SQL :=          'select '||L_PK||', '                                                || K_EOL;
                    L_SQL := L_SQL || ' '|| L_COL_REC.NAME || ' as text'                           || K_EOL;
                    L_SQL := L_SQL || '  from '||L_COL_REC.SCHEMA_NAME||'.'||L_COL_REC.TABLE_NAME  || K_EOL;
                    L_SQL := L_SQL || ' where '||L_COL_REC.NAME       ||' is not null'             || K_EOL;
                    if nvl( I_ONLY_MISSING, ' ' ) = 'Y' then
                        L_SQL := L_SQL || ' and not exists (select 1 from ML_TRANSLATIONS '           || K_EOL;
                        L_SQL := L_SQL || ' where language_id = '  || L_LANG_REC.ID                || K_EOL;
                        L_SQL := L_SQL || '   and column_id   = '  || L_COL_REC.ID                 || K_EOL;
                        L_SQL := L_SQL || '   and ROW_PK      = '''  || L_COL_REC.TABLE_NAME|| '.'||L_PK||''''|| K_EOL;
                        L_SQL := L_SQL || '   and text is not null )'                              || K_EOL;
                    end if;
--dbms_output.put_line(L_SQL);

                    open L_REC_SET for L_SQL;
                    loop
                        fetch L_REC_SET into  L_ID, L_TEXT;
                        exit when L_REC_SET%notfound;

                        L_LINE := 'execute PKG_MLM.ADD_TRANSLATION( '''||L_LANG_REC.code||''', '''||L_COL_REC.SCHEMA_NAME||''', '''||L_COL_REC.TABLE_NAME||''', '''||L_COL_REC.NAME||''', '||L_ID||', '''||L_TEXT||''' );';
                        if I_DIRECTORY is not null then
                            utl_file.put_line( L_FILE, L_LINE , true );
                        else
                            dbms_output.put_line( L_LINE );
                        end if;

                    end loop;
                    close L_REC_SET;

                end loop;

                L_LINE := 'commit;';
                if I_DIRECTORY is not null then
                    utl_file.put_line( L_FILE, L_LINE , true );
                else
                    dbms_output.put_line( L_LINE );
                end if;

                if I_DIRECTORY is not null then
                    utl_file.fclose ( L_FILE );
                    utl_file.frename( nvl( I_DIRECTORY, 'DATA_FILE_DIR' ), L_FILE_NAME||'.TMP', nvl( I_DIRECTORY, 'DATA_FILE_DIR' ), L_FILE_NAME||'.SQL',false);
                end if;

            end loop;
        end if;
    exception when others then
                if I_DIRECTORY is not null then
                    if utl_file.is_open ( L_FILE ) then
                        utl_file.fclose ( L_FILE );
                    end if;
                end if;
    end write_translation_file;


end PKG_MLM;
/



/*============================================================================================*/
CREATE OR REPLACE TRIGGER TR_ML_LANGUAGES_AIUD
/*============================================================================================*/
    AFTER INSERT OR UPDATE OR DELETE ON ML_LANGUAGES 
BEGIN
    PKG_MLM.SET_GLOBALS;
END;
/



CREATE OR REPLACE FUNCTION GET_TEXT ( I_SCHEMA_NAME         in varchar2
                                    , I_TABLE_NAME          in varchar2
                                    , I_COLUMN_NAME         in varchar2
                                    , I_ROW_PK              in nvarchar2
                                    , I_TEXT                in nvarchar2 := chr( 1 )
                                    ) return nvarchar2 is
BEGIN
    RETURN PKG_MLM.GET_TEXT ( I_SCHEMA_NAME  => I_SCHEMA_NAME 
                            , I_TABLE_NAME   => I_TABLE_NAME  
                            , I_COLUMN_NAME  => I_COLUMN_NAME 
                            , I_ROW_PK       => I_ROW_PK      
                            , I_TEXT         => I_TEXT        
                            );
END;
/



/*************************************/
Prompt   G R A S Y N 
/*************************************/

/*============================================================================================*/
CREATE OR REPLACE PUBLIC SYNONYM GET_TEXT FOR GET_TEXT;
/*============================================================================================*/

/*============================================================================================*/
GRANT EXECUTE ON GET_TEXT TO PUBLIC;
/*============================================================================================*/

