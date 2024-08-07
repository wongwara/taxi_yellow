-- 8. 
DELETE FROM table_youtube_final t1
WHERE EXISTS (
    SELECT *
    FROM table_youtube_duplicates t2
    WHERE t1.id = t2.id
);
-- 37,842 rows delete
