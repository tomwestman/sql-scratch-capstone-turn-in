Select Count(Distinct utm_campaign)
From page_visits;

Select Count(Distinct utm_source)
From page_visits;

Select Distinct utm_campaign, utm_source
From page_visits;

Select Distinct page_name from page_visits;

WITH first_touch AS (
  SELECT user_id,
      MIN(timestamp) as first_touch_at
  FROM page_visits
  GROUP BY user_id),
ft_attr AS (
  SELECT ft.user_id,
      ft.first_touch_at,
      pv.utm_source,
      pv.utm_campaign
  FROM first_touch ft
  JOIN page_visits pv
    ON ft.user_id = pv.user_id
    AND ft.first_touch_at = pv.timestamp
  GROUP BY utm_campaign, utm_source),
last_touch AS (
  SELECT user_id,
      MAX(timestamp) as last_touch_at
  FROM page_visits
  WHERE page_name = '4 - purchase'
  GROUP BY user_id),
lt_attr AS (
  SELECT lt.user_id,
         lt.last_touch_at,
         pv.utm_source,
         pv.utm_campaign,
         pv.page_name
  FROM last_touch lt
  JOIN page_visits pv
    ON lt.user_id = pv.user_id
    AND lt.last_touch_at = pv.timestamp
)

SELECT Count(ft.first_touch_at),
		pv.utm_campaign
FROM first_touch ft
JOIN page_visits pv
    ON ft.user_id = pv.user_id
    AND ft.first_touch_at = pv.timestamp
GROUP BY pv.utm_campaign;


SELECT lt_attr.utm_source, lt_attr.utm_campaign, COUNT(*)
FROM lt_attr
GROUP BY 1, 2
ORDER BY 3 DESC;


SELECT COUNT(Distinct user_id)
FROM page_visits
WHERE page_name = '4 - purchase';


SELECT lt_attr.utm_campaign, COUNT(*)
FROM lt_attr
GROUP BY 1
ORDER BY 2 DESC;