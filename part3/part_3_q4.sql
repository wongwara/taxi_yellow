SELECT 
    country,
    category_title,
    total_category_videos,
    total_country_videos,
    percentage
FROM ( 
SELECT 
    country,
    category_title,
    COUNT(DISTINCT video_id) AS total_category_videos,
    SUM(COUNT(DISTINCT video_id)) OVER (PARTITION BY country) AS total_country_videos,
    ROUND((COUNT(DISTINCT video_id) * 100.0) / SUM(COUNT(DISTINCT video_id)) OVER (PARTITION BY country), 2) AS percentage,
    RANK() OVER (PARTITION BY country ORDER BY total_category_videos DESC) AS category_rank
FROM table_youtube_final
GROUP BY country, category_title)
WHERE category_rank = 1
ORDER BY country, category_title;