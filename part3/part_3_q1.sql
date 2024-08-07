USE DATABASE bde_at1;
DESC STORAGE INTEGRATION azure_bde_at1;

-- 1. Top 3 most viewed vidoes in Sport
SELECT  country, 
        title, 
        channelTitle, 
        view_count, 
        rank
FROM (
    SELECT 
        country,
        title,
        channelTitle,
        view_count,
        ROW_NUMBER() OVER(PARTITION BY country ORDER BY view_count DESC) AS rank
    FROM table_youtube_final
    WHERE category_title = 'Sports'
      AND trending_date = '2021-10-17'
) ranked_videos
WHERE rank <= 3
ORDER BY country, rank;
