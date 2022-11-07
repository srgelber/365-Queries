-- Lab 5
-- sgelber
-- May 14, 2022

USE `AIRLINES`;
-- AIRLINES-1
-- Find all airports with exactly 17 outgoing flights. Report airport code and the full name of the airport sorted in alphabetical order by the code.
SELECT Source, Name FROM flights
JOIN airports ON flights.Source = airports.Code
GROUP BY Source
HAVING count(*) = 17
ORDER BY Source;


USE `AIRLINES`;
-- AIRLINES-2
-- Find the number of airports from which airport ANP can be reached with exactly one transfer. Make sure to exclude ANP itself from the count. Report just the number.
SELECT count(distinct flights.source) as AirportCount FROM flights
JOIN flights f1 ON f1.source = flights.destination
WHERE flights.source != 'ANP' and flights.destination != 'ANP'
and f1.destination = 'ANP';


USE `AIRLINES`;
-- AIRLINES-3
-- Find the number of airports from which airport ATE can be reached with at most one transfer. Make sure to exclude ATE itself from the count. Report just the number.
SELECT count(distinct flights.source) AS AirportCount FROM flights
JOIN flights f1 ON f1.source = flights.destination
WHERE flights.source != 'ATE'
and (f1.destination = 'ATE' or flights.destination = 'ATE');


USE `AIRLINES`;
-- AIRLINES-4
-- For each airline, report the total number of airports from which it has at least one outgoing flight. Report the full name of the airline and the number of airports computed. Report the results sorted by the number of airports in descending order. In case of tie, sort by airline name A-Z.
SELECT Name, Count(distinct source) as Airports FROM airlines
JOIN flights on airlines.Id = flights.Airline
GROUP BY Name
ORDER BY Airports DESC, Name;


USE `BAKERY`;
-- BAKERY-1
-- For each flavor which is found in more than three types of items offered at the bakery, report the flavor, the average price (rounded to the nearest penny) of an item of this flavor, and the total number of different items of this flavor on the menu. Sort the output in ascending order by the average price.
SELECT Flavor, round(sum(Price)/count(*),2) as AveragePrice, count(*) as DifferentPastries FROM goods
GROUP BY Flavor
HAVING Count(Food) > 3
ORDER BY AveragePrice;


USE `BAKERY`;
-- BAKERY-2
-- Find the total amount of money the bakery earned in October 2007 from selling eclairs. Report just the amount.
SELECT SUM(Price) as EclairRevenue FROM goods
JOIN items ON items.Item = goods.GId
JOIN receipts ON receipts.RNumber = items.Receipt
WHERE Month(SaleDate) = 10 and Year(SaleDate) = 2007 and Food = 'Eclair';


USE `BAKERY`;
-- BAKERY-3
-- For each visit by NATACHA STENZ output the receipt number, sale date, total number of items purchased, and amount paid, rounded to the nearest penny. Sort by the amount paid, greatest to least.
SELECT Receipt, SaleDate, Count(*) as NumberOfItems, Round(sum(Price),2) as CheckAmount FROM goods
JOIN items ON items.Item = goods.GId
JOIN receipts ON receipts.RNumber = items.Receipt
JOIN customers On receipts.Customer = customers.CId
WHERE FirstName = 'NATACHA' AND LastName = 'STENZ'
GROUP BY Receipt
ORDER BY CheckAmount DESC;


USE `BAKERY`;
-- BAKERY-4
-- For the week starting October 8, report the day of the week (Monday through Sunday), the date, total number of purchases (receipts), the total number of pastries purchased, and the overall daily revenue rounded to the nearest penny. Report results in chronological order.
SELECT DAYNAME(SaleDate) as Day, SaleDate, count(distinct receipt) as Receipts,
count(Item) as Items, round(sum(Price),2) as Revenue 
FROM goods
JOIN items ON items.Item = goods.GId
JOIN receipts ON receipts.RNumber = items.Receipt
WHERE Month(SaleDate) = 10 and Day(SaleDate) >= 8 and Day(SaleDate) <= 14
GROUP BY Day, SaleDate
ORDER BY SaleDate;


USE `BAKERY`;
-- BAKERY-5
-- Report all dates on which more than ten tarts were purchased, sorted in chronological order.
SELECT SaleDate FROM goods
JOIN items ON items.Item = goods.GId
JOIN receipts ON receipts.RNumber = items.Receipt
WHERE Food = 'Tart'
GROUP BY SaleDate
HAVING Count(*) > 10
ORDER BY SaleDate;


USE `CSU`;
-- CSU-1
-- For each campus that averaged more than $2,500 in fees between the years 2000 and 2005 (inclusive), report the campus name and total of fees for this six year period. Sort in ascending order by fee.
SELECT Campus, sum(fee) as Total FROM campuses
JOIN fees on fees.CampusId = campuses.Id
WHERE fees.Year between 2000 and 2005
GROUP BY Campus
HAVING (sum(fee)/count(fee)) > 2500
ORDER BY Total;


USE `CSU`;
-- CSU-2
-- For each campus for which data exists for more than 60 years, report the campus name along with the average, minimum and maximum enrollment (over all years). Sort your output by average enrollment.
SELECT Campus, sum(Enrolled)/count(Enrolled) as Average,
Min(Enrolled) as Minimum, Max(Enrolled) as Maximum FROM enrollments
JOIN campuses on campuses.Id = enrollments.CampusId
GROUP BY Campus
HAVING Count(enrollments.Year) > 60
ORDER BY Average;


USE `CSU`;
-- CSU-3
-- For each campus in LA and Orange counties report the campus name and total number of degrees granted between 1998 and 2002 (inclusive). Sort the output in descending order by the number of degrees.

SELECT Campus, sum(degrees.degrees) as Total FROM campuses
JOIN degrees ON degrees.CampusId = campuses.Id
WHERE degrees.Year between 1998 and 2002 and (County = 'Orange' or County = 'Los Angeles')
GROUP BY Campus
ORDER BY Total DESC;


USE `CSU`;
-- CSU-4
-- For each campus that had more than 20,000 enrolled students in 2004, report the campus name and the number of disciplines for which the campus had non-zero graduate enrollment. Sort the output in alphabetical order by the name of the campus. (Exclude campuses that had no graduate enrollment at all.)
SELECT Campus, count(*) as NonZeroDisciplineTotal from campuses
JOIN discEnr ON discEnr.CampusId = campuses.Id
JOIN disciplines ON discEnr.Discipline = disciplines.Id
JOIN enrollments ON enrollments.CampusId = campuses.Id
WHERE discEnr.Year = 2004 and discEnr.Gr > 0 and enrollments.Year = discEnr.Year
and Enrolled > 20000
GROUP BY Campus
ORDER BY Campus;


USE `INN`;
-- INN-1
-- For each room, report the full room name, total revenue (number of nights times per-night rate), and the average revenue per stay. In this summary, include only those stays that began in the months of September, October and November of calendar year 2010. Sort output in descending order by total revenue. Output full room names.
SELECT RoomName, ROUND(SUM(Rate * DATEDIFF(CheckOut,CheckIn)),2) as TotalRevenue,
ROUND(ROUND(SUM(Rate * DATEDIFF(CheckOut,CheckIn)),2)/count(code),2) as AveragePerStay from rooms
JOIN reservations ON reservations.Room = rooms.RoomCode
WHERE Year(CheckIn) = 2010 and (Month(CheckIn) = 9 or Month(CheckIn) = 10 or Month(CheckIn) = 11)
GROUP BY RoomName
ORDER BY TotalRevenue DESC;


USE `INN`;
-- INN-2
-- Report the total number of reservations that began on Fridays, and the total revenue they brought in.
SELECT Count(*) as Stays, ROUND(SUM(Rate * DATEDIFF(CheckOut,CheckIn)),2) as TotalRevenue from rooms
JOIN reservations ON reservations.Room = rooms.RoomCode
WHERE DAYOFWEEK(CheckIn) = 6
GROUP BY DAYOFWEEK(CheckIN)
ORDER BY TotalRevenue DESC;


USE `INN`;
-- INN-3
-- List each day of the week. For each day, compute the total number of reservations that began on that day, and the total revenue for these reservations. Report days of week as Monday, Tuesday, etc. Order days from Sunday to Saturday.
SELECT DAYNAME(CheckIn) as Day, Count(*) as Stays, SUM(Rate * DATEDIFF(CheckOut,CheckIn)) as Revenue from rooms
JOIN reservations ON reservations.Room = rooms.RoomCode
GROUP BY DAYNAME(CheckIn), DAYOFWEEK(CheckIn)
ORDER BY DAYOFWEEK(CheckIN);


USE `INN`;
-- INN-4
-- For each room list full room name and report the highest markup against the base price and the largest markdown (discount). Report markups and markdowns as the signed difference between the base price and the rate. Sort output in descending order beginning with the largest markup. In case of identical markup/down sort by room name A-Z. Report full room names.
SELECT Roomname, max(Rate - basePrice) as Markup, min(Rate - basePrice) as Discount FROM rooms
JOIN reservations ON reservations.Room = rooms.RoomCode
GROUP BY Roomname
ORDER BY Markup DESC, Roomname;


USE `INN`;
-- INN-5
-- For each room report how many nights in calendar year 2010 the room was occupied. Report the room code, the full name of the room, and the number of occupied nights. Sort in descending order by occupied nights. (Note: this should be number of nights during 2010. Some reservations extend beyond December 31, 2010. The ”extra” nights in 2011 must be deducted).
SELECT RoomCode, RoomName, sum(CASE
    WHEN CheckOut > '2010-12-31' and CheckIn < '2010-01-01' THEN 365
    WHEN CheckOut > '2010-12-31' THEN DATEDIFF('2010-12-31', CheckIn)
    WHEN CheckIn < '2010-01-01' THEN DATEDIFF(CheckOut, '2010-01-01')
    ELSE DATEDIFF(CheckOut, CheckIn)
END) as DaysOccupied
from rooms
JOIN reservations ON reservations.Room = rooms.RoomCode
WHERE Year(CheckIn) <= 2010 AND Year(CheckOut) >= 2010
GROUP BY RoomCode, RoomName
ORDER BY DaysOccupied DESC;


USE `KATZENJAMMER`;
-- KATZENJAMMER-1
-- For each performer, report first name and how many times she sang lead vocals on a song. Sort output in descending order by the number of leads. In case of tie, sort by performer first name (A-Z.)
SELECT Firstname, count(*) FROM Performance
JOIN Band on Band.Id = Performance.Bandmate
JOIN Vocals on Vocals.Song = Performance.Song 
and Vocals.Bandmate = Performance.Bandmate
WHERE VocalType = 'lead'
GROUP BY Firstname
ORDER BY count(*) DESC, Firstname;


USE `KATZENJAMMER`;
-- KATZENJAMMER-2
-- Report how many different instruments each performer plays on songs from the album 'Le Pop'. Include performer's first name and the count of different instruments. Sort the output by the first name of the performers.
SELECT Firstname, count(distinct Instrument) as InstrumentCount FROM Instruments
JOIN Songs ON Songs.SongId = Instruments.Song
JOIN Band ON Band.Id = Instruments.Bandmate
JOIN Tracklists ON Tracklists.Song = Songs.SongId
JOIN Albums ON Albums.AId = Tracklists.Album
WHERE Albums.Title = 'Le Pop'
GROUP BY Firstname
ORDER BY Firstname;


USE `KATZENJAMMER`;
-- KATZENJAMMER-3
-- List each stage position along with the number of times Turid stood at each stage position when performing live. Sort output in ascending order of the number of times she performed in each position.

SELECT StagePosition, count(*) as Count FROM Performance
JOIN Band ON Band.Id = Performance.Bandmate
Where Firstname = 'Turid'
GROUP BY StagePosition
ORDER BY Count;


USE `KATZENJAMMER`;
-- KATZENJAMMER-4
-- Report how many times each performer (other than Anne-Marit) played bass balalaika on the songs where Anne-Marit was positioned on the left side of the stage. List performer first name and a number for each performer. Sort output alphabetically by the name of the performer.

SELECT Band.Firstname, count(*) as Bass FROM Performance
JOIN Band ON Band.Id = Performance.Bandmate
JOIN Instruments on Instruments.Bandmate = Band.Id 
and Instruments.Song = Performance.Song
JOIN Performance P1 ON P1.Song = Performance.Song
JOIN Band B1 ON B1.Id = P1.Bandmate
WHERE Band.Firstname != 'Anne-Marit' and P1.StagePosition = 'left' and
B1.Firstname = 'Anne-Marit' and Instruments.Instrument = 'bass balalaika'
GROUP BY Firstname
ORDER BY Firstname;


USE `KATZENJAMMER`;
-- KATZENJAMMER-5
-- Report all instruments (in alphabetical order) that were played by three or more people.
SELECT Instrument FROM Instruments
GROUP BY Instrument
HAVING Count(Distinct Bandmate) >= 3
ORDER BY Instrument;


USE `KATZENJAMMER`;
-- KATZENJAMMER-6
-- For each performer, list first name and report the number of songs on which they played more than one instrument. Sort output in alphabetical order by first name of the performer
SELECT Distinct Firstname, count(Song) over (partition by Bandmate) as MultiInstrumentCount FROM Instruments
JOIN Band ON Band.Id = Instruments.Bandmate
GROUP BY Bandmate, Song
HAVING count(distinct Instrument) > 1
ORDER BY Firstname;


USE `MARATHON`;
-- MARATHON-1
-- List each age group and gender. For each combination, report total number of runners, the overall place of the best runner and the overall place of the slowest runner. Output result sorted by age group and sorted by gender (F followed by M) within each age group.
SELECT AgeGroup, Sex, count(*) as Total, min(Place) as BestPlacing,
max(Place) as SlowestPlacing FROM marathon
GROUP BY AgeGroup, Sex
ORDER BY AgeGroup, Sex;


USE `MARATHON`;
-- MARATHON-2
-- Report the total number of gender/age groups for which both the first and the second place runners (within the group) are from the same state.
SELECT count(*) as Total FROM marathon
JOIN marathon m1 ON marathon.AgeGroup = m1.AgeGroup and marathon.Sex = m1.Sex
WHERE marathon.GroupPlace = 1 and m1.GroupPlace = 2 and m1.State = marathon.State
GROUP BY marathon.GroupPlace;


USE `MARATHON`;
-- MARATHON-3
-- For each full minute, report the total number of runners whose pace was between that number of minutes and the next. In other words: how many runners ran the marathon at a pace between 5 and 6 mins, how many at a pace between 6 and 7 mins, and so on.
SELECT distinct MINUTE(Pace) as PaceMinutes, Count(Firstname) as Count from marathon
GROUP BY MINUTE(Pace);


USE `MARATHON`;
-- MARATHON-4
-- For each state with runners in the marathon, report the number of runners from the state who finished in top 10 in their gender-age group. If a state did not have runners in top 10, do not output information for that state. Report state code and the number of top 10 runners. Sort in descending order by the number of top 10 runners, then by state A-Z.
SELECT State, count(*) as NumberofTop10 FROM marathon
WHERE GroupPlace <= 10
GROUP BY State
ORDER BY NumberofTop10 DESC, State;


USE `MARATHON`;
-- MARATHON-5
-- For each Connecticut town with 3 or more participants in the race, report the town name and average time of its runners in the race computed in seconds. Output the results sorted by the average time (lowest average time first).
SELECT Town, ROUND(AVG(TIME_TO_SEC(RunTime)),1) as AverageTimeInSeconds FROM marathon
WHERE State = 'CT'
GROUP BY Town
HAVING count(BibNumber) >= 3
ORDER BY AverageTimeInSeconds;


USE `STUDENTS`;
-- STUDENTS-1
-- Report the last and first names of teachers who have between seven and eight (inclusive) students in their classrooms. Sort output in alphabetical order by the teacher's last name.
SELECT teachers.Last, teachers.First FROM teachers
JOIN list on list.classroom = teachers.classroom
GROUP BY teachers.Last, teachers.First
HAVING count(*) between 7 and 8
ORDER BY teachers.Last;


USE `STUDENTS`;
-- STUDENTS-2
-- For each grade, report the grade, the number of classrooms in which it is taught, and the total number of students in the grade. Sort the output by the number of classrooms in descending order, then by grade in ascending order.

SELECT Grade, count(distinct classroom) as Classrooms, count(*) as Students FROM list
GROUP BY Grade
ORDER BY Classrooms DESC, Grade ASC;


USE `STUDENTS`;
-- STUDENTS-3
-- For each Kindergarten (grade 0) classroom, report classroom number along with the total number of students in the classroom. Sort output in the descending order by the number of students.
SELECT Classroom, count(*) as Students FROM list
WHERE Grade = 0
GROUP BY Classroom
ORDER BY Students DESC;


USE `STUDENTS`;
-- STUDENTS-4
-- For each fourth grade classroom, report the classroom number and the last name of the student who appears last (alphabetically) on the class roster. Sort output by classroom.
SELECT Classroom, max(LastName) as LastOnRoster FROM list
WHERE Grade = 4
GROUP BY Classroom
ORDER BY Classroom;


