create database Indian_Election_Results;

use Indian_Election_Results;

select * from constituencywise_details;
select * from constituencywise_results;
select * from partywise_results;
select * from statewise_results;
select * from states;

desc constituencywise_details;
desc constituencywise_results;
desc partywise_results;
desc statewise_results;
desc states;

/* for constituencywise_details table */
ALTER TABLE constituencywise_details
MODIFY COLUMN Candidate VARCHAR(50) NOT NULL;
ALTER TABLE constituencywise_details
MODIFY COLUMN Party VARCHAR(100) NOT NULL;
ALTER TABLE  constituencywise_details
CHANGE COLUMN `Constituency ID` Constituency_ID varchar(20);
ALTER TABLE  constituencywise_details
CHANGE COLUMN `Total Votes` Total_Votes int;
ALTER TABLE  constituencywise_details
CHANGE COLUMN `% of Votes` per_of_Votes double;
ALTER TABLE constituencywise_details
ADD CONSTRAINT PRIMARY KEY (Constituency_ID);
ALTER TABLE constituencywise_details
ADD COLUMN Constituency_ID INT AUTO_INCREMENT PRIMARY KEY FIRST;

/* for constituencywise_results table */
ALTER TABLE constituencywise_results
MODIFY COLUMN Parliament_Constituency VARCHAR(100);
ALTER TABLE constituencywise_results
MODIFY COLUMN Winning_Candidate VARCHAR(100);
ALTER TABLE constituencywise_results
MODIFY COLUMN Constituency_Name VARCHAR(100);
ALTER TABLE  constituencywise_results
CHANGE COLUMN `Constituency ID` Constituency_ID varchar(50);
ALTER TABLE  constituencywise_results
CHANGE COLUMN `Party ID` Party_ID int;
ALTER TABLE constituencywise_results
ADD CONSTRAINT PRIMARY KEY (Parliament_Constituency,Constituency_ID);
ALTER TABLE constituencywise_results
ADD CONSTRAINT PRIMARY KEY (Constituency_ID);
ALTER TABLE constituencywise_results DROP PRIMARY KEY;
desc constituencywise_results;

/* for Partywise_results table */
ALTER TABLE  partywise_results
CHANGE COLUMN `Party ID` Party_ID int;
ALTER TABLE partywise_results
ADD CONSTRAINT PRIMARY KEY (Party_ID);

/*statewise_results */
desc statewise_results;
ALTER TABLE statewise_results
MODIFY COLUMN Constituency VARCHAR(100);
ALTER TABLE statewise_results
MODIFY COLUMN State VARCHAR(100);
ALTER TABLE statewise_results
MODIFY COLUMN Status VARCHAR(100);
ALTER TABLE  statewise_results
CHANGE COLUMN `Const. No.` Const_No int;
ALTER TABLE  statewise_results
CHANGE COLUMN `Parliament Constituency` Parliament_Constituency varchar(100);
ALTER TABLE  statewise_results
CHANGE COLUMN `Leading Candidate` Leading_Candidate varchar(100);
ALTER TABLE  statewise_results
CHANGE COLUMN `Trailing Candidate` Trailing_Candidate varchar(100);
ALTER TABLE  statewise_results
CHANGE COLUMN `State ID` State_ID varchar(100);
ALTER TABLE statewise_results
ADD CONSTRAINT PRIMARY KEY (Parliament_Constituency);

/* for states table altering pk for state_id*/
ALTER TABLE states 
MODIFY COLUMN State_ID VARCHAR(10) NOT NULL;
ALTER TABLE states 
ADD CONSTRAINT PRIMARY KEY (State_ID);
ALTER TABLE states 
MODIFY COLUMN State VARCHAR(100) NOT NULL;


##QUERY EXECUTION:---
#1.TOTAL SEATES
select distinct count(Parliament_Constituency) as total_seats
   from constituencywise_results;

#2. What are the total number of seats avialable for election in each states
select s.State as State_Name,
      count(cr.Constituency_ID) as Total_avialable_seats
       from constituencywise_results cr 
       join statewise_results sr
       on cr.Parliament_Constituency = sr.Parliament_Constituency
       join states s
       on s.State_ID = sr.State_ID
group by s.State
order by s.State;

#3. Total seats won by NDA Alliance
select 
   sum( case 
        when Party in 
         ( 'Bharatiya Janata Party - BJP', 
                'Telugu Desam - TDP', 
				'Janata Dal  (United) - JD(U)',
                'Shiv Sena - SHS', 
                'AJSU Party - AJSUP', 
                'Apna Dal (Soneylal) - ADAL', 
                'Asom Gana Parishad - AGP',
                'Hindustani Awam Morcha (Secular) - HAMS', 
				'Janasena Party - JnP', 
				'Janata Dal  (Secular) - JD(S)',
                'Lok Janshakti Party(Ram Vilas) - LJPRV', 
                'Nationalist Congress Party - NCP',
                'Rashtriya Lok Dal - RLD', 
                'Sikkim Krantikari Morcha - SKM'
                ) then Won
         else 0
         end) as NDA_total_seats_won
from partywise_results;

#4. seats won by NDA Allience parties
select Party as Party_name,
      Won as Seats_won
from partywise_results
where Party in('Bharatiya Janata Party - BJP', 
                'Telugu Desam - TDP', 
				'Janata Dal  (United) - JD(U)',
                'Shiv Sena - SHS', 
                'AJSU Party - AJSUP', 
                'Apna Dal (Soneylal) - ADAL', 
                'Asom Gana Parishad - AGP',
                'Hindustani Awam Morcha (Secular) - HAMS', 
				'Janasena Party - JnP', 
				'Janata Dal  (Secular) - JD(S)',
                'Lok Janshakti Party(Ram Vilas) - LJPRV', 
                'Nationalist Congress Party - NCP',
                'Rashtriya Lok Dal - RLD', 
                'Sikkim Krantikari Morcha - SKM')
                order by Seats_won desc;
                
#5. Total seats won by I.N.D.I.A Allience
select 
  sum(case
  when Party in ('Indian National Congress - INC',
                'Aam Aadmi Party - AAAP',
                'All India Trinamool Congress - AITC',
                'Bharat Adivasi Party - BHRTADVSIP',
                'Communist Party of India  (Marxist) - CPI(M)',
                'Communist Party of India  (Marxist-Leninist)  (Liberation) - CPI(ML)(L)',
                'Communist Party of India - CPI',
                'Dravida Munnetra Kazhagam - DMK',
                'Indian Union Muslim League - IUML',
                'Nat`Jammu & Kashmir National Conference - JKN',
                'Jharkhand Mukti Morcha - JMM',
                'Jammu & Kashmir National Conference - JKN',
                'Kerala Congress - KEC',
                'Marumalarchi Dravida Munnetra Kazhagam - MDMK',
                'Nationalist Congress Party Sharadchandra Pawar - NCPSP',
                'Rashtriya Janata Dal - RJD',
                'Rashtriya Loktantrik Party - RLTP',
                'Revolutionary Socialist Party - RSP',
                'Samajwadi Party - SP',
                'Shiv Sena (Uddhav Balasaheb Thackrey) - SHSUBT',
                'Viduthalai Chiruthaigal Katchi - VCK')
               then Won
                else 0
            end) INDIA_total_seats_won
  from partywise_results;
  
#6. Seats won by I.N.D.I.A Allience
select Party as Party_name,
Won as seats_won
from partywise_results
where Party in ('Indian National Congress - INC',
                'Aam Aadmi Party - AAAP',
                'All India Trinamool Congress - AITC',
                'Bharat Adivasi Party - BHRTADVSIP',
                'Communist Party of India  (Marxist) - CPI(M)',
                'Communist Party of India  (Marxist-Leninist)  (Liberation) - CPI(ML)(L)',
                'Communist Party of India - CPI',
                'Dravida Munnetra Kazhagam - DMK',
                'Indian Union Muslim League - IUML',
                'Nat`Jammu & Kashmir National Conference - JKN',
                'Jharkhand Mukti Morcha - JMM',
                'Jammu & Kashmir National Conference - JKN',
                'Kerala Congress - KEC',
                'Marumalarchi Dravida Munnetra Kazhagam - MDMK',
                'Nationalist Congress Party Sharadchandra Pawar - NCPSP',
                'Rashtriya Janata Dal - RJD',
                'Rashtriya Loktantrik Party - RLTP',
                'Revolutionary Socialist Party - RSP',
                'Samajwadi Party - SP',
                'Shiv Sena (Uddhav Balasaheb Thackrey) - SHSUBT',
                'Viduthalai Chiruthaigal Katchi - VCK')
   order by seats_won desc;
   
#7. Add new column feild in table partywise_results to get the party allienz as NDA I.N.D.I.A and other
select * from partywise_results;
#1st step:-
  alter table partywise_results
    add Party_Allience varchar(50);
#2nd step:-
SET SQL_SAFE_UPDATES = 0;
  update partywise_results
   set Party_Allience = 'I.N.D.I.A'
   where Party In ('Indian National Congress - INC',
                   'Aam Aadmi Party - AAAP',
                   'All India Trinamool Congress - AITC',
                   'Bharat Adivasi Party - BHRTADVSIP',
                   'Communist Party of India  (Marxist) - CPI(M)',
				   'Communist Party of India  (Marxist-Leninist)  (Liberation) - CPI(ML)(L)',
                   'Communist Party of India - CPI',
                   'Dravida Munnetra Kazhagam - DMK',	
                   'Indian Union Muslim League - IUML',
                   'Jammu & Kashmir National Conference - JKN',
				   'Jharkhand Mukti Morcha - JMM',
                   'Kerala Congress - KEC',
                   'Marumalarchi Dravida Munnetra Kazhagam - MDMK',
                   'Nationalist Congress Party Sharadchandra Pawar - NCPSP',
                   'Rashtriya Janata Dal - RJD',
                   'Rashtriya Loktantrik Party - RLTP',
				   'Revolutionary Socialist Party - RSP',
                   'Samajwadi Party - SP',
                   'Shiv Sena (Uddhav Balasaheb Thackrey) - SHSUBT',
				   'Viduthalai Chiruthaigal Katchi - VCK');
#3rd step:-
 update partywise_results
 set Party_Allience = 'NDA'
 where Party in ('Bharatiya Janata Party - BJP',
    'Telugu Desam - TDP',
    'Janata Dal  (United) - JD(U)',
    'Shiv Sena - SHS',
    'AJSU Party - AJSUP',
    'Apna Dal (Soneylal) - ADAL',
    'Asom Gana Parishad - AGP',
    'Hindustani Awam Morcha (Secular) - HAMS',
    'Janasena Party - JnP',
    'Janata Dal  (Secular) - JD(S)',
    'Lok Janshakti Party(Ram Vilas) - LJPRV',
    'Nationalist Congress Party - NCP',
    'Rashtriya Lok Dal - RLD',
    'Sikkim Krantikari Morcha - SKM');
#4th step:--
update partywise_results
set Party_Allience = 'Other'
where Party_Allience is Null;
SET SQL_SAFE_UPDATES = 1;
    
#8. Which party allience (NDA,I.N.D.I.A ,Other)won the most seats across all states
SELECT 
    pr.Party_Allience,
    COUNT(cr.Constituency_ID) AS seats_won
FROM
    constituencywise_results cr
        JOIN
    partywise_results pr ON cr.Party_ID = pr.Party_ID
WHERE
    pr.Party_Allience IN ('NDA' , 'I.N.D.I.A', 'Other')
GROUP BY pr.Party_Allience
ORDER BY seats_won DESC;
 
 #9. Winning candidate's name, their party name,
 #----total votes, and the margin of victory for a specific state and constituency?
 select cr.Winning_Candidate,
        cr.Constituency_Name as Candidate_name,
        pr.Party as Party_name,
        pr.Party_Allience,
        cr.Total_Votes,
        cr.Margin,
        s.State as state_name
        from constituencywise_results cr
        join partywise_results pr on cr.Party_ID = cr.Party_ID
        join statewise_results sr on cr.Parliament_Constituency = sr.Parliament_Constituency
        join States s on sr.State_ID = s.State_ID
       where s.State = 'Uttar Pradesh' and cr.Constituency_Name = 'AMETHI';
        
#10. What is the distribution of EVM votes versus postal votes for candidates in a specific constituency?
select cd.Candidate,
	   cd.Party,
       cd.EVM_Votes,
       cd.Postal_Votes,
       cd.Total_Votes,
       cr.Constituency_Name
from constituencywise_details cd
join constituencywise_results cr
 on cr.Constituency_ID = cd.Constituency_ID
 where cr.Constituency_Name = 'KOLHAPUR'
 order by cd.Total_Votes desc; 
 
 #11. Which parties won the most seats in s State, and how many seats did each party win?
 select pr.Party,
	count(cr.Constituency_ID) as seats_won
from constituencywise_results cr
join partywise_results pr 
on cr.Party_ID = pr.Party_ID
join statewise_results sr
on cr.Parliament_Constituency = sr.Parliament_Constituency
join States s on sr.State_ID = s.State_ID
where s.State = 'Andhra Pradesh'
group by pr.Party
order by seats_won desc;

#12. Which candidate received the highest number of EVM votes in each constituency (Top 10)?
SELECT 
    cr.Constituency_Name,
    cd.Constituency_ID,
    cd.Candidate,
    cd.EVM_Votes
FROM
    constituencywise_details cd
        JOIN
    constituencywise_results cr ON cd.Constituency_ID = cr.Constituency_ID
WHERE
    cd.EVM_Votes = (SELECT 
            MAX(EVM_Votes)
        FROM
            constituencywise_details cds
        WHERE
            cds.Constituency_ID = cd.Constituency_ID)
ORDER BY cd.EVM_Votes DESC;
