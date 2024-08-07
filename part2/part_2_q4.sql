UPDATE 
    table_youtube_final
SET 
    table_youtube_final.category_title = table_youtube_category.category_title
FROM 
    table_youtube_category
WHERE 
    table_youtube_final.categoryID = table_youtube_category.categoryID
  AND 
      table_youtube_final.category_title IS NULL;