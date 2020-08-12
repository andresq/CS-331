-- Deletes if already made QueensClassScheduleSpring2019
-- USE master;
-- GO
-- ALTER DATABASE QueensClassScheduleSpring2019 SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
-- GO
-- DROP DATABASE QueensClassScheduleSpring2019;
-- GO

CREATE DATABASE QueensClassScheduleSpring2019;
GO
USE [QueensClassScheduleSpring2019];
GO
CREATE SCHEMA Uploadfile;
GO
CREATE SCHEMA Project3;
GO
--
SELECT *
INTO QueensClassScheduleSpring2019.Uploadfile.CoursesSpring2019
FROM QueensCollegeSchedulSpring2019.Uploadfile.CoursesSpring2019;
GO
SELECT *
INTO QueensClassScheduleSpring2019.Uploadfile.Instructors
FROM QueensCollegeSchedulSpring2019.YourLastName.Instructors
GO
-------------------------------------------------------------------------------------------------------------
CREATE SCHEMA [Process]
GO
--CREATE SCHEMA [PkSequence]
--GO
DROP TABLE IF EXISTS [Process].[WorkflowSteps]
GO
--DROP SEQUENCE IF EXISTS PkSequence.WorkflowStepsSequenceObject
--CREATE SEQUENCE PkSequence.WorkflowStepsSequenceObject AS INT MINVALUE 1;
CREATE TABLE [Process].[WorkflowSteps](
	[WorkFlowStepKey] [int] IDENTITY(1, 1) NOT NULL,
	[WorkFlowStepDescription] [nvarchar](100) NOT NULL,
	[WorkFlowStepTableRowCount] [int] NULL
        DEFAULT 0,

	[LastName] [NVARCHAR](30) NULL 
        DEFAULT 'Your last name',
    [FirstName] [NVARCHAR](30) NULL 
        DEFAULT 'Your first name',
	[StartingDateTime] [DATETIME2](7) NULL
        DEFAULT (SYSDATETIME()),
    [EndingDateTime] [DATETIME2](7) NULL
        DEFAULT (SYSDATETIME()),
	[ClassTime] [NVARCHAR](5) NULL 
        DEFAULT '9:15',
	[QmailAddress] [NVARCHAR](50) NULL 
        DEFAULT 'Your Qmail Email Address',
    [AuthorizedUserId] [INT] NULL 
        DEFAULT NULL,

    CONSTRAINT [PK_WorkflowSteps]
        PRIMARY KEY CLUSTERED ([WorkFlowStepKey] ASC)
) 
GO
-------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS [Project3].[Class]
GO
CREATE TABLE [Project3].[Class]
(
    [ClassID] [INT] IDENTITY(1, 1) NOT NULL,
    [Sec] [NVARCHAR](30) NOT NULL,
    [Code] [INT] NOT NULL,
    [CourseID] [INT] NOT NULL,
    [Day] [NVARCHAR](50) NULL DEFAULT 'TBD',
    [Time] [NVARCHAR](50) NULL DEFAULT 'TBD',
    [InstructorID] [INT] NOT NULL,
    [RoomID] [INT] NOT NULL,
    [Enrolled] [INT] NOT NULL,
    [Limit] [INT] NOT NULL,
    [ModeOfInstructionID] [INT] NOT NULL,
    [Semester] [NVARCHAR](50) NOT NULL
        DEFAULT 'Spring 2019',

    [ClassTime] [NVARCHAR](5) NULL 
        DEFAULT '9:15',
    [LastName] [NVARCHAR](30) NULL 
        DEFAULT 'Your last name',
    [FirstName] [NVARCHAR](30) NULL 
        DEFAULT 'Your first name',
    [QmailAddress] [NVARCHAR](50) NULL 
        DEFAULT 'Your Qmail Email Address',
    [DateAdded] [DATETIME2] 
        DEFAULT SYSDATETIME(),
    [DateOfLastUpdate] [DATETIME2] 
        DEFAULT SYSDATETIME(),
    [AuthorizedUserId] [INT] NULL 
        DEFAULT NULL,
    
    CONSTRAINT [PK_Class]
        PRIMARY KEY CLUSTERED ([ClassID] ASC)
);
GO
-------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS [Project3].[Department]
GO
CREATE TABLE [Project3].[Department]
(
    [DepartmentID] [INT] IDENTITY(1, 1) NOT NULL,
    [DepartmentName] [NVARCHAR](10) NOT NULL,

    [ClassTime] [NVARCHAR](5) NULL
        DEFAULT '9:15',
    [LastName] [NVARCHAR](30) NULL
        DEFAULT 'Your last name',
    [FirstName] [NVARCHAR](30) NULL
        DEFAULT 'Your first name',
    [QmailAddress] [NVARCHAR](50) NULL
        DEFAULT 'Your Qmail Email Address',
    [DateAdded] [DATETIME2]
        DEFAULT SYSDATETIME(),
    [DateOfLastUpdate] [DATETIME2]
        DEFAULT SYSDATETIME(),
    [AuthorizedUserId] [INT] NULL
        DEFAULT NULL,
    
    CONSTRAINT [PK_Department]
        PRIMARY KEY CLUSTERED ([DepartmentID] ASC)
);
GO
----------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS [Project3].[Course]
GO
CREATE TABLE [Project3].[Course]
(
    [CourseID] [INT] IDENTITY(1, 1) NOT NULL,
    [CourseName] [NVARCHAR] (20) NOT NULL,
    [Hours] [FLOAT] NOT NULL
        CHECK (Hours BETWEEN 0 AND 200),
    [Credits] [FLOAT] NOT NULL
        CHECK (Credits BETWEEN 0 AND 20),
    [Description] [NVARCHAR](50) NOT NULL,
    [DepartmentID] [INT] NOT NULL,

    [ClassTime] [NVARCHAR](5) NULL
        DEFAULT '9:15',
    [LastName] [NVARCHAR](30) NULL
        DEFAULT 'Your last name',
    [FirstName] [NVARCHAR](30) NULL
        DEFAULT 'Your first name',
    [QmailAddress] [NVARCHAR](50) NULL
        DEFAULT 'Your Qmail Email Address',
    [DateAdded] [DATETIME2]
        DEFAULT SYSDATETIME(),
    [DateOfLastUpdate] [DATETIME2]
        DEFAULT SYSDATETIME(),
    [AuthorizedUserId] [INT] NULL
        DEFAULT NULL,

    CONSTRAINT [PK_Course]
        PRIMARY KEY CLUSTERED ([CourseID] ASC)
);
GO
-------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS [Project3].[Instructors]
GO
CREATE TABLE [Project3].[Instructors](
    [InstructorID] [INT] IDENTITY(1, 1) NOT NULL,
    [InstructorFirstName] [NVARCHAR](50) NOT NULL , 
    [InstructorLastname] [NVARCHAR](50) NOT NULL,
    [FullName] AS CONCAT(InstructorFirstName,' ',InstructorLastname) PERSISTED,

    [ClassTime] [NVARCHAR](5) NULL
        DEFAULT '9:15',
    [LastName] [NVARCHAR](30) NULL
        DEFAULT 'Your last name',
    [FirstName] [NVARCHAR](30) NULL
        DEFAULT 'Your first name',
    [QmailAddress] [NVARCHAR](50) NULL
        DEFAULT 'Your Qmail Email Address',
    [DateAdded] [DATETIME2]
        DEFAULT SYSDATETIME(),
    [DateOfLastUpdate] [DATETIME2]
        DEFAULT SYSDATETIME(),
    [AuthorizedUserId] [INT] NULL
        DEFAULT NULL,
    
    CONSTRAINT [PK_Instructors]
        PRIMARY KEY CLUSTERED ([InstructorID] ASC)
);
GO
-------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS [Project3].[Building]
GO
CREATE TABLE [Project3].[Building]
(
    [BuildingID] INT IDENTITY(1,1) NOT NULL,
    [BuildingName] NVARCHAR(30) NOT NULL,
 
    [ClassTime] [NVARCHAR](5) NULL
        DEFAULT '9:15',
    [LastName] [NVARCHAR](30) NULL
        DEFAULT 'Your last name',
    [FirstName] [NVARCHAR](30) NULL
        DEFAULT 'Your first name',
    [QmailAddress] [NVARCHAR](50) NULL
        DEFAULT 'Your Qmail Email Address',
    [DateAdded] [DATETIME2]
        DEFAULT SYSDATETIME(),
    [DateOfLastUpdate] [DATETIME2]
        DEFAULT SYSDATETIME(),
    [AuthorizedUserId] [INT] NULL
        DEFAULT NULL,

    CONSTRAINT [PK_Building]
        PRIMARY KEY CLUSTERED ([BuildingID] ASC)
);
GO
-------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS [Project3].[Room]
GO
CREATE TABLE [Project3].[Room]
(
    [RoomID] [INT] IDENTITY(1,1) NOT NULL,
    [RoomNumber] [NVARCHAR] (10) NOT NULL,
    [BuildingID] [INT] NOT NULL,

    [ClassTime] [NVARCHAR](5) NULL
        DEFAULT '9:15',
    [LastName] [NVARCHAR](30) NULL
        DEFAULT 'Your last name',
    [FirstName] [NVARCHAR](30) NULL
        DEFAULT 'Your first name',
    [QmailAddress] [NVARCHAR](50) NULL
        DEFAULT 'Your Qmail Email Address',
    [DateAdded] [DATETIME2]
        DEFAULT SYSDATETIME(),
    [DateOfLastUpdate] [DATETIME2]
        DEFAULT SYSDATETIME(),
    [AuthorizedUserId] [INT] NULL
        DEFAULT NULL,

    CONSTRAINT [PK_Room]
        PRIMARY KEY CLUSTERED ([RoomID] ASC),
);
GO
-------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS [Project3].[ModeOfInstruction]
GO
CREATE TABLE [Project3].[ModeOfInstruction](
    [ModeOfInstructionID] [INT] IDENTITY(1, 1) NOT NULL,
    [ModeType] [NVARCHAR](15) NULL,

    [ClassTime] [NVARCHAR](5) NULL
        DEFAULT '9:15',
    [LastName] [NVARCHAR](30) NULL
        DEFAULT 'Your last name',
    [FirstName] [NVARCHAR](30) NULL
        DEFAULT 'Your first name',
    [QmailAddress] [NVARCHAR](50) NULL
        DEFAULT 'Your Qmail Email Address',
    [DateAdded] [DATETIME2]
        DEFAULT SYSDATETIME(),
    [DateOfLastUpdate] [DATETIME2]
        DEFAULT SYSDATETIME(),
    [AuthorizedUserId] [INT] NULL
        DEFAULT NULL,

    CONSTRAINT [PK_ModeOfInstruction]
        PRIMARY KEY CLUSTERED ([ModeOfInstructionID] ASC),
);
GO