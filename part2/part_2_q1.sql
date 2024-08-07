USE DATABASE bde_at1;
DESC STORAGE INTEGRATION azure_bde_at1;

-- 1. If not, consider the categoryid,
-- we have 29 category_title with 11 times appears in the table and the comedy category appear 22 times.

SELECT
    COUNT(*), 
    category_title
FROM
    table_youtube_category
GROUP BY
    category_title
HAVING 
    COUNT(*) > 1;