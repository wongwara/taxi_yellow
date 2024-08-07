SELECT
    channelTitle,
    COUNT(DISTINCT video_id) AS distinct_video_count
FROM table_youtube_final
GROUP BY channeltitle
ORDER BY distinct_video_count DESC
LIMIT 1;