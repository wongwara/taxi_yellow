-- 4.1 The category with the highest view_count in each country
-- the results reveal 'People & Blogs' to consistently rank as the top category in six out of eleven countries
WITH categories_ranking AS (
    SELECT
        country,
        category_title,
        COUNT(*) AS video_count,
        SUM(view_count) AS total_view_count,
        MAX(view_count) AS highest_views,
        ROUND(AVG(view_count) ,2) AS avg_views,
        RANK() OVER (PARTITION BY country ORDER BY SUM(view_count) DESC) AS category_rank
    FROM table_youtube_final
    WHERE category_title NOT IN ('Music', 'Entertainment')
    GROUP BY country, category_title
)
SELECT
    country,
    category_title,
    highest_views,
    avg_views,
    total_view_count
FROM categories_ranking
WHERE category_rank < 2
ORDER BY country;

-- 4.2 The likes ratio in the “People & Blogs” category
WITH Ranking AS (
    SELECT
        country,
        COUNT(*) AS video_count,
        category_title,
        ROUND((SUM(likes) / NULLIF(SUM(view_count), 0)) * 100, 2) AS likes_ratio,
        RANK() OVER (PARTITION BY country ORDER BY likes_ratio DESC) AS likes_rank,
        RANK() OVER (PARTITION BY country ORDER BY SUM(view_count) DESC) AS category_rank
    FROM table_youtube_final
    WHERE category_title NOT IN ('Music', 'Entertainment')
    GROUP BY country, category_title
)

SELECT
    country,
    category_title,
    video_count,
    likes_ratio,
    likes_rank,
    category_rank
FROM Ranking
WHERE category_title = ('People & Blogs')
GROUP BY country, category_title, likes_rank, likes_ratio, video_count ,category_rank
ORDER BY country;
