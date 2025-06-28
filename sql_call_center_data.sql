SELECT * FROM call_center_calls
WHERE call_type = 'Inbound' and resolution_status = 'Resolved';

SHOW COLUMNS call_center_calls;

--DESCRIBING DATA 
SELECT column_name
FROM information_schema.columns
WHERE table_name = 'call_center_calls';

--Find duplicate records based on agent, date, customer.
SELECT agent_id, call_date, customer_id,
COUNT(*) as duplicate_count 
FROM call_center_calls
GROUP BY agent_id, call_date, customer_id
HAVING count(*) > 1;

SELECT *
FROM call_center_calls
WHERE (agent_id, call_date, customer_id) IN (
    SELECT 
        agent_id, call_date, customer_id
    FROM 
        call_center_calls
    GROUP BY 
        agent_id, call_date, customer_id
    HAVING 
        COUNT(*) > 1
);

--Count calls per agent and average quality score.
SELECT agent_id, agent_name, count(*) AS total_calls, ROUND(AVG(quality_score),2) AS avg_q_s
FROM call_center_calls 
GROUP BY agent_id, agent_name
ORDER BY total_calls DESC;

--To list all red flag cases along with their resolution status,
SELECT * FROM call_center_calls
WHERE red_flag = TRUE
ORDER BY call_date;


--To find customers who made more than one call
SELECT customer_id, COUNT(*) AS total_calls
FROM call_center_calls
GROUP BY customer_id
HAVING COUNT(*) > 1
ORDER BY total_calls DESC;

--To deduplicate the call_center_calls table by keeping only the latest call per customer
with CTE as(
     SELECT *,
	 ROW_NUMBER() OVER(PARTITION BY customer_id ORDER BY call_date DESC) AS rn
	 FROM call_center_calls
	 )
SELECT * FROM CTE 
WHERE rn = 1;

--To find the average quality score for each issue_category
SELECT
    issue_category,
    COUNT(*) AS total_calls,
    ROUND(AVG(quality_score), 2) AS avg_quality_score
FROM
    call_center_calls
GROUP BY
    issue_category
ORDER BY
    avg_quality_score DESC;

		 
	 