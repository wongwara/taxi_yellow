-- 3. which video is the most viewed and what is its likes_ratio 
WITH Ranked_videos AS (
    SELECT 
        country,
        trending_date,
        video_id,
        title,
        channelTitle,
        category_title,
        view_count,
        likes,
        ROUND((likes / NULLIF(view_count, 0)) * 100, 2) AS likes_ratio,
        ROW_NUMBER() OVER (PARTITION BY country, EXTRACT(YEAR FROM trending_date), EXTRACT(MONTH FROM trending_date) ORDER BY view_count DESC) AS rank_num
    FROM table_youtube_final
)
SELECT
    country,
    DATE_TRUNC('month',trending_date)  AS year_month,
    title,
    channelTitle,
    category_title,
    view_count,
    likes_ratio
FROM Ranked_videos
WHERE rank_num = 1
ORDER BY year_month, country;