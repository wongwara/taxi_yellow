-- create a new database
-- CREATE DATABASE bde_at1;

USE DATABASE bde_at1;

DROP STORAGE INTEGRATION azure_bde_at1;

CREATE STORAGE INTEGRATION azure_bde_at1
  TYPE = EXTERNAL_STAGE
  STORAGE_PROVIDER = AZURE
  ENABLED = TRUE
  AZURE_TENANT_ID = 'e8911c26-cf9f-4a9c-878e-527807be8791'
  STORAGE_ALLOWED_LOCATIONS = ('azure://utsbde14191732.blob.core.windows.net/bde-at1');

DESC STORAGE INTEGRATION azure_bde_at1;

DROP TABLE IF EXISTS ex_table_youtube_trending;
DROP TABLE IF EXISTS table_youtube_trending;
DROP TABLE IF EXISTS table_youtube_category;
DROP TABLE IF EXISTS ex_table_youtube_category;
DROP TABLE IF EXISTS table_youtube_final;

-- create a new stage 
CREATE OR REPLACE STAGE stage_bde_at1
STORAGE_INTEGRATION = azure_bde_at1
URL='azure://utsbde14191732.blob.core.windows.net/bde-at1';

-- list stage
list @stage_bde_at1;

CREATE OR REPLACE FILE FORMAT file_format_csv
TYPE = 'CSV'
FIELD_DELIMITER = ','
SKIP_HEADER = 1
NULL_IF = ('\\N', 'NULL', 'NUL', '')
FIELD_OPTIONALLY_ENCLOSED_BY = '"'
;

CREATE OR REPLACE EXTERNAL TABLE ex_table_youtube_trending
WITH LOCATION = @stage_bde_at1
FILE_FORMAT = file_format_csv
PATTERN = '.*\.csv';

SELECT *
FROM BDE_AT1.PUBLIC.ex_table_youtube_trending
LIMIT 1;

-- create a new table call table_youtube_trending
CREATE OR REPLACE TABLE table_youtube_trending AS
SELECT
    value:c1::VARCHAR AS video_id,
    value:c2::VARCHAR AS title,
    value:c3::VARCHAR AS publishedAt,
    value:c4::VARCHAR AS channelID,
    value:c5::VARCHAR AS channelTitle,
    value:c6::VARCHAR AS categoryID,
    value:c7::VARCHAR AS trending_date,
    value:c8::VARCHAR AS view_count,
    value:c9::VARCHAR AS likes,
    value:c10::VARCHAR AS dislikes,
    value:c11::VARCHAR AS comment_count,
    value:c12::VARCHAR AS comment_disabled
FROM ex_table_youtube_trending;

SELECT COUNT(*)
FROM table_youtube_trending;
-- 1,175,478 rows

SELECT *
FROM table_youtube_trending;

--correct type
CREATE OR REPLACE TABLE table_youtube_trending AS
SELECT
    value:c1::VARCHAR AS video_id,
    value:c2::VARCHAR AS title,
    value:c3::TIMESTAMP_NTZ AS publishedAt,
    value:c4::VARCHAR AS channelID,
    value:c5::VARCHAR AS channelTitle,
    value:c6::INT AS categoryID,
    value:c7::DATE AS trending_date,
    value:c8::INT AS view_count,
    value:c9::VARCHAR AS likes,
    value:c10::VARCHAR AS dislikes,
    value:c11::VARCHAR AS comment_count,
    value:c12::BOOLEAN AS comment_disabled,
    SPLIT_PART(metadata$filename, '_', 1)::VARCHAR AS country
FROM ex_table_youtube_trending;

--check number of rows
SELECT COUNT(*)
FROM table_youtube_trending;
-- 1,175,478 rows

-- check the new table
SELECT *
FROM BDE_AT1.PUBLIC.table_youtube_trending
LIMIT 10;


-- to save all data in csv
SELECT *
FROM BDE_AT1.PUBLIC.table_youtube_trending;

-- for json files create an external table
CREATE OR REPLACE EXTERNAL TABLE ex_table_youtube_category
WITH LOCATION = @stage_bde_at1
FILE_FORMAT = (TYPE=json, STRIP_OUTER_ARRAY=TRUE)
PATTERN = '.*\.json';

-- select every rows of the ex_table_youtube_categoty
SELECT *
FROM BDE_AT1.PUBLIC.ex_table_youtube_category
LIMIT 1;

--For JSON files
CREATE OR REPLACE TABLE table_youtube_category AS
SELECT
  SPLIT_PART(metadata$filename, '_', 1)::VARCHAR AS country,
  l.value:id::INT as categoryID,
  l.value:snippet:title::VARCHAR as category_title
FROM ex_table_youtube_category
, LATERAL FLATTEN(value:items) l;

--check number of rows
SELECT COUNT(*)
FROM table_youtube_category;
-- 342 rows

-- select every rows of the ex_table_youtube_categoty
SELECT *
FROM table_youtube_category;

CREATE OR REPLACE TABLE table_youtube_final AS
SELECT
    UUID_STRING() AS id,
    yt_trending.video_id,
    yt_trending.title,
    yt_trending.publishedAt,
    yt_trending.channelID,
    yt_trending.channelTitle,
    yt_trending.categoryID,
    yt_category.category_title,
    yt_trending.trending_date,
    yt_trending.view_count,
    yt_trending.likes,
    yt_trending.dislikes,
    yt_trending.comment_count,
    yt_trending.comment_disabled,
    yt_trending.country
FROM 
    table_youtube_trending yt_trending
LEFT JOIN 
    table_youtube_category yt_category
    ON 
    yt_trending.country = yt_category.country
    AND 
    yt_trending.categoryID = yt_category.categoryID;
    

-- select every rows of the ex_table_youtube_categoty
SELECT COUNT(*)
FROM table_youtube_final;
-- 1,175,478 rows