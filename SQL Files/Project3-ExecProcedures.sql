USE [QueensClassScheduleSpring2019]
GO


-- EXEC only once
EXEC Project3.LoadStarSchemaData




-- Created by Ishan Shrestha
-- 4 more queries of your choice and their proposition

-- Propositon : How many students are enrolled in each mode of instruction?

SELECT [ModeOfInstruction].[ModeOfInstructionID], [ModeOfInstruction].[ModeType], SUM([Class].[Enrolled]) AS [TotalStudents]
FROM [Project3].[Class]
INNER JOIN [Project3].[ModeOfInstruction]  
ON [Class].[ModeOfInstructionID] = [ModeOfInstruction].[ModeOfInstructionID]
GROUP BY [ModeOfInstruction].[ModeOfInstructionID], [ModeOfInstruction].[ModeType]

-- Propositon : Show the class code, class section, instructorID, Instructor Fullname of all the instructors.

SELECT [Instructors].[InstructorID], [Instructors].[FullName], [Class].[Code], [Class].[Sec] 
FROM [Project3].[instructors]
INNER JOIN [Project3].[Class]  
ON [Instructors].[InstructorID] = [Class].[InstructorID]


-- Proposition : Show the class day, time, classId, coursename, credits and description of all 3 credit classes.

SELECT [Course].[coursename],[Course].[credits],[Course].[description], [Class].[ClassID], [Class].[day], [Class].[time]
FROM [Project3].[Class]
INNER JOIN [Project3].[Course]  
ON [Class].[courseid] = [course].[courseid]
WHERE [course].[credits] = 3;

--Proposition : show the class ID, class time, class day, room number, building name and mode type of all the Hybrid classes.

SELECT [Class].[ClassID], [Class].[day], [Class].[time], [Room].[roomnumber], [Room].[BuildingID], [ModeOfInstruction].[ModeType]
FROM [Project3].[Class]
INNER JOIN [Project3].[Room] 
ON [Class].[RoomId] = [Room].[RoomID]
INNER JOIN [Project3].[ModeOfInstruction] 
ON [Class].[ModeOfInstructionID] = [ModeOfInstruction].[ModeOfInstructionID]
WHERE [ModeOfInstruction].[ModeType] = 'Hybrid';
