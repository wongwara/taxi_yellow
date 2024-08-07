-- 2.    which category_title only appears in one country?
SELECT 
    COUNT(*), 
    category_title
FROM 
    table_youtube_category
GROUP BY 
    category_title
HAVING 
    COUNT(DISTINCT country) = 1;

-- counts the occurrences of each distinct category_title, then filters the results to reveal only those with counts more than one, which are considered duplicates.
