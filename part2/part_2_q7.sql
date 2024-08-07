CREATE OR REPLACE TABLE table_youtube_duplicates AS
SELECT
    *
FROM (
    SELECT
        id,
        video_id,
        title,
        publishedAt,
        channelID,
        channelTitle,
        categoryID,
        category_title,
        trending_date,
        view_count,
        likes,
        dislikes,
        comment_count,
        comment_disabled,
        country,
        ROW_NUMBER() OVER (PARTITION BY video_id, country, trending_date ORDER BY view_count DESC) AS row_num
    FROM table_youtube_final
) AS Duplicate
WHERE row_num > 1;