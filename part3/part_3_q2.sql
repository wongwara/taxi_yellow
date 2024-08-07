-- 2.
SELECT 
    country,
    COUNT(DISTINCT video_id) AS CT
FROM 
    table_youtube_final
WHERE 
    title LIKE '%BTS%'
GROUP BY 
    country
ORDER BY 
    CT DESC;