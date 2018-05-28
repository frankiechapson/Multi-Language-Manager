/************************************************************
    Author  :   Ferenc Toth 
    Remark  :   Adding English to MULTILANG
    Date    :   2015.07.01
************************************************************/


Prompt *****************************************************************
Prompt **                 A D D I N G   U S E N G L I S H             **
Prompt *****************************************************************

INSERT INTO ML_LANGUAGES ( ID, CODE, TEXT, IS_DEFAULT ) VALUES ( 2, 'USA', 'American', 'N' );

INSERT INTO ML_NLS_SETTINGS( ID , LANGUAGE_ID, NLS_PARAMETER_ID, SETTING )  VALUES ( 21, 2,  1, 'BINARY'                       );     -- NLS_COMP
INSERT INTO ML_NLS_SETTINGS( ID , LANGUAGE_ID, NLS_PARAMETER_ID, SETTING )  VALUES ( 22, 2,  2, 'BINARY'                       );     -- NLS_SORT
INSERT INTO ML_NLS_SETTINGS( ID , LANGUAGE_ID, NLS_PARAMETER_ID, SETTING )  VALUES ( 23, 2,  3, 'GREGORIAN'                    );     -- NLS_CALENDAR
INSERT INTO ML_NLS_SETTINGS( ID , LANGUAGE_ID, NLS_PARAMETER_ID, SETTING )  VALUES ( 24, 2,  4, 'AMERICAN'                     );     -- NLS_LANGUAGE
INSERT INTO ML_NLS_SETTINGS( ID , LANGUAGE_ID, NLS_PARAMETER_ID, SETTING )  VALUES ( 25, 2,  5, 'AMERICA'                      );     -- NLS_TERRITORY
INSERT INTO ML_NLS_SETTINGS( ID , LANGUAGE_ID, NLS_PARAMETER_ID, SETTING )  VALUES ( 26, 2,  6, 'DD-MON-RR'                    );     -- NLS_DATE_FORMAT
INSERT INTO ML_NLS_SETTINGS( ID , LANGUAGE_ID, NLS_PARAMETER_ID, SETTING )  VALUES ( 27, 2,  7, 'HH.MI.SSXFF AM'               );     -- NLS_TIME_FORMAT
INSERT INTO ML_NLS_SETTINGS( ID , LANGUAGE_ID, NLS_PARAMETER_ID, SETTING )  VALUES ( 28, 2,  8, 'DD-MON-RR HH.MI.SSXFF AM'     );     -- NLS_TIMESTAMP_FORMAT
INSERT INTO ML_NLS_SETTINGS( ID , LANGUAGE_ID, NLS_PARAMETER_ID, SETTING )  VALUES ( 29, 2,  9, 'DD-MON-RR HH.MI.SSXFF AM TZR' );     -- NLS_TIMESTAMP_TZ_FORMAT
INSERT INTO ML_NLS_SETTINGS( ID , LANGUAGE_ID, NLS_PARAMETER_ID, SETTING )  VALUES ( 30, 2, 10, 'AMERICAN'                     );     -- NLS_DATE_LANGUAGE   
INSERT INTO ML_NLS_SETTINGS( ID , LANGUAGE_ID, NLS_PARAMETER_ID, SETTING )  VALUES ( 31, 2, 11, '$'                            );     -- NLS_CURRENCY      
INSERT INTO ML_NLS_SETTINGS( ID , LANGUAGE_ID, NLS_PARAMETER_ID, SETTING )  VALUES ( 32, 2, 12, 'AMERICA'                      );     -- NLS_ISO_CURRENCY
INSERT INTO ML_NLS_SETTINGS( ID , LANGUAGE_ID, NLS_PARAMETER_ID, SETTING )  VALUES ( 33, 2, 13, '$'                            );     -- NLS_DUAL_CURRENCY
INSERT INTO ML_NLS_SETTINGS( ID , LANGUAGE_ID, NLS_PARAMETER_ID, SETTING )  VALUES ( 34, 2, 14, '.,'                           );     -- NLS_NUMERIC_CHARACTERS

COMMIT;

