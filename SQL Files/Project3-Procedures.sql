USE [QueensClassScheduleSpring2019];
GO
SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO
-------------------------------------------------------------------------------------------------------------
-- =============================================
-- Author: Weiwei Ye
-- Procedure: Project3.AddForeignKeysToStarSchemaData
-- Create date: 05/08/2020
-- Description:	Loads the data to Add ForeignKeys to each table.
-- =============================================
CREATE OR ALTER PROCEDURE [Project3].[AddForeignKeysToStarSchemaData]
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @CurrentTime DATETIME2 = SYSDATETIME();

    ALTER TABLE [Project3].[Class]
		WITH CHECK ADD CONSTRAINT [FK_CourseID] FOREIGN KEY ([CourseID]) REFERENCES [Project3].[Course]([CourseID]);

	ALTER TABLE [Project3].[Class] CHECK CONSTRAINT [FK_CourseID];

    ALTER TABLE [Project3].[Class]
		WITH CHECK ADD CONSTRAINT [FK_InstructorID] FOREIGN KEY ([InstructorID]) REFERENCES [Project3].[Instructors]([InstructorID]);

	ALTER TABLE [Project3].[Class] CHECK CONSTRAINT [FK_InstructorID];

    ALTER TABLE [Project3].[Class]
		WITH CHECK ADD CONSTRAINT [FK_RoomID] FOREIGN KEY ([RoomID]) REFERENCES [Project3].[Room]([RoomID]);

	ALTER TABLE [Project3].[Class] CHECK CONSTRAINT [FK_RoomID];

    ALTER TABLE [Project3].[Class]
		WITH CHECK ADD CONSTRAINT [FK_ModeOfInstructionID] FOREIGN KEY ([ModeOfInstructionID]) REFERENCES [Project3].[ModeOfInstruction]([ModeOfInstructionID]);

	ALTER TABLE [Project3].[Class] CHECK CONSTRAINT [FK_ModeOfInstructionID];

    ALTER TABLE [Project3].[Course]
		WITH CHECK ADD CONSTRAINT [FK_DepartmentID] FOREIGN KEY ([DepartmentID]) REFERENCES [Project3].[Department]([DepartmentID]);

	ALTER TABLE [Project3].[Course] CHECK CONSTRAINT [FK_DepartmentID];

	ALTER TABLE [Project3].[Room]
		WITH CHECK ADD CONSTRAINT [FK_BuildingID] FOREIGN KEY ([BuildingID]) REFERENCES [Project3].[Building]([BuildingID]);

	ALTER TABLE [Project3].[Room] CHECK CONSTRAINT [FK_BuildingID];

    EXEC Process.usp_TrackWorkFlow @StartTime = @CurrentTime,
                                   @WorkFlowDescription = 'AddForeignKeysToStarSchemaData',
                                   @WorkFlowStepTableRowCount = @@RowCount
END;
GO
-------------------------------------------------------------------------------------------------------------
-- =============================================
-- Author: Weiwei Ye
-- Procedure: Project3.DropForeignKeysFromStarSchemaData
-- Create date: 05/08/2020
-- Description:	Loads the data to drop ForeignKeys in each table.
-- =============================================
CREATE OR ALTER PROCEDURE [Project3].[DropForeignKeysFromStarSchemaData]
AS
BEGIN
	SET NOCOUNT ON;
    DECLARE @CurrentTime DATETIME2 = SYSDATETIME();

    ALTER TABLE [Project3].[Class]
    DROP CONSTRAINT IF EXISTS [FK_CourseID];

    ALTER TABLE [Project3].[Class]
    DROP CONSTRAINT IF EXISTS [FK_InstructorID];

    ALTER TABLE [Project3].[Class]
    DROP CONSTRAINT IF EXISTS [FK_RoomID];

    ALTER TABLE [Project3].[Class]
    DROP CONSTRAINT IF EXISTS [FK_ModeOfInstructionID];

    ALTER TABLE [Project3].[Course]
    DROP CONSTRAINT IF EXISTS [FK_DepartmentID];

	ALTER TABLE [Project3].[Room]
    DROP CONSTRAINT IF EXISTS [FK_BuildingID];
    
    EXEC Process.usp_TrackWorkFlow @StartTime = @CurrentTime,
                                   @WorkFlowDescription = 'DropForeignKeysFromStarSchemaData',
                                   @WorkFlowStepTableRowCount = @@RowCount
END;
GO
-------------------------------------------------------------------------------------------------------------
-- =============================================
-- Author: Tiara Williams
-- Procedure: Process.usp_TrackWorkFlow
-- Create date: 05/08/2020
-- Description:	Track Work Flow of each procedure.
-- =============================================
CREATE OR ALTER PROCEDURE[Process].[usp_TrackWorkFlow] 
   @StartTime DATETIME2,    
   @WorkFlowDescription NVARCHAR(100),     
   @WorkFlowStepTableRowCount int
AS
BEGIN
	INSERT INTO Process.WorkflowSteps
    (
        WorkFlowStepDescription, 
        WorkFlowStepTableRowCount, 
        StartingDateTime,
        LastName,
        FirstName,
        QmailAddress,
        AuthorizedUserId
    )
    VALUES 
        (
            @WorkFlowDescription, 
            @WorkFlowStepTableRowCount, 
            @StartTime,
            'Tiara',
            'Williams',
            'Tiara.Williams40@qmail.cuny.edu',
            40
        )
END;
GO
-------------------------------------------------------------------------------------------------------------
-- =============================================
-- Author: Tiara Williams
-- Procedure: Process.usp_ShowWorkflowSteps
-- Create date: 05/08/2020
-- Description:	show the WorkflowSteps table.
-- =============================================
CREATE OR ALTER PROCEDURE [Process].usp_ShowWorkflowSteps
AS
BEGIN
    SET NOCOUNT ON;

    SELECT *
    FROM Process.WorkflowSteps;
END;
GO
-------------------------------------------------------------------------------------------------------------
-- =============================================
-- Author: Weiwei Ye
-- Procedure: Project3.TruncateStarSchemaData
-- Create date: 05/08/2020
-- Description:	Truncate datas in each table.
-- =============================================
CREATE OR ALTER PROCEDURE [Project3].[TruncateStarSchemaData]
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @CurrentTime DATETIME2 = SYSDATETIME();
    TRUNCATE TABLE [Process].WorkflowSteps;
    TRUNCATE TABLE [Project3].Building;
    TRUNCATE TABLE [Project3].Class;
    TRUNCATE TABLE [Project3].Course;
    TRUNCATE TABLE [Project3].Department;
    TRUNCATE TABLE [Project3].Instructors;
    TRUNCATE TABLE [Project3].ModeOfInstruction;
    TRUNCATE TABLE [Project3].Room;

    EXEC Process.usp_TrackWorkFlow @StartTime = @CurrentTime,
                                   @WorkFlowDescription = 'TruncateStarSchemaData',
                                   @WorkFlowStepTableRowCount = @@RowCount

END;
GO
-------------------------------------------------------------------------------------------------------------
-- =============================================
-- Author: Weiwei Ye
-- Procedure: Project3.LoadStarSchemaData
-- Create date: 05/08/2020
-- Description:	Run all procedures.
-- =============================================
CREATE OR ALTER PROCEDURE [Project3].[LoadStarSchemaData]
AS
BEGIN
    SET NOCOUNT ON;

    --
    --	Drop All of the foreign keys prior to truncating tables in the star schema
    --
    EXEC [Project3].[DropForeignKeysFromStarSchemaData];
    --
    --	Check row count before truncation
 
    --	Always truncate the Star Schema Data
    --
    EXEC [Project3].[TruncateStarSchemaData];
    --
    --	Load the star schema
    --
    EXEC [Project3].[Load_Department]; 
    EXEC [Project3].[Load_Course];
    EXEC [Project3].[Load_Instructors];
    EXEC [Project3].[Load_Building];
    EXEC [Project3].[Load_Room];
    EXEC [Project3].[Load_ModeOfInstruction];
    EXEC [Project3].[Load_Class];
    --
    --
    --	Check row count before truncation
    EXEC [Project3].[ShowTableStatusRowCount];
    EXEC [Project3].[AddForeignKeysToStarSchemaData]; 
END;
GO
-------------------------------------------------------------------------------------------------------------
-- =============================================
-- Author: Zihao Yin
-- Procedure: Project3.Load_Department
-- Create date: 05/06/2020
-- Description:	Loads the data to Department table.
-- =============================================
CREATE OR ALTER PROCEDURE [Project3].[Load_Department]
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;
    DECLARE @CurrentTime DATETIME2 = SYSDATETIME();
    INSERT INTO QueensClassScheduleSpring2019.[Project3].[Department]
    (
        DepartmentName,
        LastName,
        FirstName,
        QmailAddress,
        AuthorizedUserId
    )
    SELECT DISTINCT
           (LEFT([Course (hr, crd)], CHARINDEX(' ', [Course (hr, crd)]) - 1)) AS DepartmentName,
           'Zihao',
           'Yin',
           'Zihao.yin14@qmail.cuny.edu',
           14
    FROM QueensClassScheduleSpring2019.Uploadfile.CoursesSpring2019
    WHERE (CHARINDEX(' ', [Course (hr, crd)]) - 1 > 0)
          AND (LEFT([Course (hr, crd)], CHARINDEX(' ', [Course (hr, crd)]) - 1)) IS NOT NULL;

    EXEC Process.usp_TrackWorkFlow @StartTime = @CurrentTime,
                                   @WorkFlowDescription = 'Load_Department',
                                   @WorkFlowStepTableRowCount = @@RowCount
END;
GO
-------------------------------------------------------------------------------------------------------------
-- =============================================
-- Author: Zihao Yin
-- Procedure: Project3.LoadCourse
-- Create date: 05/06/2020
-- Description:	Loads the data to Course table.
-- =============================================
CREATE OR ALTER PROCEDURE [Project3].[Load_Course]
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;
    DECLARE @CurrentTime DATETIME2 = SYSDATETIME();
    INSERT INTO QueensClassScheduleSpring2019.[Project3].Course
    (
        CourseName,
        Hours,
        Credits,
        Description,
        DepartmentID,
        LastName,
        FirstName,
        QmailAddress,
        AuthorizedUserId
    )
    SELECT DISTINCT
           new.CourseName,
           new.Hours,
           new.Credits,
           new.description,
           D.DepartmentID,
           'Zihao',
           'Yin',
           'Zihao.yin14@qmail.cuny.edu',
           14
    FROM
    (
        SELECT DISTINCT
               (LEFT([Course (hr, crd)], CHARINDEX(' ', [Course (hr, crd)], CHARINDEX(' ', [Course (hr, crd)]) + 1) - 1)) AS CourseName,
               CAST(SUBSTRING(
                                 [Course (hr, crd)],
                                 CHARINDEX('(', [Course (hr, crd)]) + 1,
                                 CHARINDEX(',', [Course (hr, crd)]) - CHARINDEX('(', [Course (hr, crd)]) - 1
                             ) AS FLOAT) AS Hours,
               CAST(SUBSTRING(
                                 [Course (hr, crd)],
                                 CHARINDEX(',', [Course (hr, crd)]) + 1,
                                 CHARINDEX(')', [Course (hr, crd)]) - CHARINDEX(',', [Course (hr, crd)]) - 1
                             ) AS FLOAT) AS Credits,
               description
        FROM QueensClassScheduleSpring2019.Uploadfile.CoursesSpring2019
        WHERE CHARINDEX(' ', [Course (hr, crd)], CHARINDEX(' ', [Course (hr, crd)]) + 1) - 1 > 0
              AND CHARINDEX('(', [Course (hr, crd)]) > 0
              AND CHARINDEX(')', [Course (hr, crd)]) > 0
    ) AS new
        INNER JOIN QueensClassScheduleSpring2019.Project3.Department AS D
            ON D.DepartmentName = (LEFT(new.CourseName, CHARINDEX(' ', new.CourseName) - 1));

    
    EXEC Process.usp_TrackWorkFlow @StartTime = @CurrentTime,
                                   @WorkFlowDescription = 'Load_Course',
                                   @WorkFlowStepTableRowCount = @@RowCount

END;
GO
-------------------------------------------------------------------------------------------------------------


-------------------------------------------------------------------------------------------------------------
-- =============================================
-- Author: Ishan Shrestha
-- Procedure: [Project3].[Instructors]
-- Create date: 05/07/2020
-- Description:	Loads the data to [Project3].[Instructors] table from [YourLastName].[Instructors] .
-- =============================================
CREATE OR ALTER PROCEDURE [Project3].[Load_Instructors]
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;
    DECLARE @CurrentTime DATETIME2 = SYSDATETIME();
    INSERT INTO [QueensClassScheduleSpring2019].[Project3].Instructors
    (
        
        InstructorLastName,
        InstructorFirstName,
        FirstName,
        Lastname,
        QmailAddress,
        AuthorizedUserId
        
    )
    SELECT 
        CASE CHARINDEX(',', InstructorName) WHEN 0 THEN InstructorName
        ELSE LEFT(InstructorName,CHARINDEX(',', InstructorName)- 1) END AS InstructorLastName,
        CASE CHARINDEX(',', InstructorName) WHEN 0 THEN InstructorName
        ELSE Substring(InstructorName, Charindex(',', InstructorName)+2, LEN(InstructorName)) END AS  InstructorFirstName,
        'Ishan',
        'Shrestha',
        'Ishan.Shrestha24@qmail.cuny.edu',
        24
    FROM [QueensClassScheduleSpring2019].Uploadfile.[Instructors]
    
    EXEC Process.usp_TrackWorkFlow @StartTime = @CurrentTime,
                                   @WorkFlowDescription = 'Load_Instructors',
                                   @WorkFlowStepTableRowCount = @@RowCount
    
END;
GO
-------------------------------------------------------------------------------------------------------------
-- =============================================
-- Author: Andres Quintero
-- Procedure: Project3.Load_Building
-- Create date: 05/08/2020
-- Description:	Loads the data to Building table.
-- =============================================
CREATE OR ALTER PROCEDURE [Project3].[Load_Building]
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from   
    -- interfering with SELECT statements.
    SET NOCOUNT ON;
    DECLARE @CurrentTime DATETIME2 = SYSDATETIME();
    INSERT INTO QueensClassScheduleSpring2019.[Project3].Building
    (
        BuildingName
        , LastName
        , FirstName
        , QmailAddress
        , AuthorizedUserId
    )
    SELECT DISTINCT 
        CASE [Location] WHEN '' THEN 'TBD'
        ELSE LEFT([Location], CHARINDEX(' ', [Location]) - 1) END AS BuildingName
        , 'Quintero'
        , 'Andres'
        , 'Andres.Quintero71@qmail.cuny.edu'
        , 71
    FROM Uploadfile.CoursesSpring2019
    -- WHERE LEN([Location]) <> 0
    
    EXEC Process.usp_TrackWorkFlow @StartTime = @CurrentTime,
                                   @WorkFlowDescription = 'Load_Building',
                                   @WorkFlowStepTableRowCount = @@RowCount
END;
GO
-------------------------------------------------------------------------------------------------------------
-- =============================================
-- Author: Andres Quintero
-- Procedure: Project3.Load_Room
-- Create date: 05/08/2020
-- Description:	Loads the data to Room table.
-- =============================================
CREATE OR ALTER PROCEDURE [Project3].[Load_Room]
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from   
    -- interfering with SELECT statements.
    SET NOCOUNT ON;
    DECLARE @CurrentTime DATETIME2 = SYSDATETIME();
    INSERT INTO QueensClassScheduleSpring2019.[Project3].Room
    (
        RoomNumber
        , BuildingID
        , LastName
        , FirstName
        , QmailAddress
        , AuthorizedUserId
    )
    SELECT DISTINCT CASE [Location] WHEN '' THEN 'TBD'
        ELSE SUBSTRING([Location], CHARINDEX(' ', [Location]) + 1, LEN([Location])) END AS RoomNumber
        , ID.BuildingID AS BuildingID
        , 'Quintero'
        , 'Andres'
        , 'Andres.Quintero71@qmail.cuny.edu'
        , '71'
    FROM QueensClassScheduleSpring2019.Uploadfile.CoursesSpring2019
    INNER JOIN Project3.Building AS ID
        ON CASE [Location] WHEN '' THEN 'TBD'
            ELSE LEFT([Location], CHARINDEX(' ', [Location]) - 1) END
            = ID.BuildingName


    EXEC Process.usp_TrackWorkFlow @StartTime = @CurrentTime,
                                   @WorkFlowDescription = 'Load_Room',
                                   @WorkFlowStepTableRowCount = @@RowCount
END;
GO
-------------------------------------------------------------------------------------------------------------
-- =============================================
-- Author: Weiwei Ye
-- Procedure: Project3.Load_ModeOfInstruction
-- Create date: 05/08/2020
-- Description:	Loads the data to ModeOfInstruction table.
-- =============================================
CREATE OR ALTER PROCEDURE [Project3].[Load_ModeOfInstruction]
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;
    DECLARE @CurrentTime DATETIME2 = SYSDATETIME();
    INSERT INTO QueensClassScheduleSpring2019.[Project3].[ModeOfInstruction]
    (
        ModeType,
        LastName,
        FirstName,
        QmailAddress,
        AuthorizedUserId
    )
    SELECT DISTINCT
        [Mode of Instruction] AS ModeType,
        'Weiwei',
        'Ye',
        'Weiwei.Ye49@qmail.cuny.edu',
        49
    FROM QueensClassScheduleSpring2019.Uploadfile.CoursesSpring2019
    WHERE [Mode of Instruction] != ' '

    EXEC Process.usp_TrackWorkFlow @StartTime = @CurrentTime,
                                   @WorkFlowDescription = 'Load_ModeOfInstruction',
                                   @WorkFlowStepTableRowCount = @@RowCount

END;
GO
-------------------------------------------------------------------------------------------------------------
-- =============================================
-- Author: Andres Quintero
-- Procedure: Project3.Load_Class
-- Create date: 05/08/2020
-- Description:	Loads the data to Class table.
-- =============================================
CREATE
    OR

ALTER PROCEDURE [Project3].[Load_Class]
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;

    INSERT INTO [Project3].Class (
        Sec
        , Code
        , [Day]
        , [Time]
        , Enrolled
        , [Limit]
        , CourseID
        , ModeOfInstructionID
        , RoomID
        , InstructorID
        , LastName
        , FirstName
        , QmailAddress
        , AuthorizedUserId
        )
     SELECT DISTINCT 
        CASE [Sec] WHEN '' THEN 'TBD' ELSE [Sec] END AS [Sec]
        , CASE [Code] WHEN '' THEN 'TBD' ELSE [Code] END AS [Code]
        , CASE [Day] WHEN '' THEN 'TBD' ELSE [Day] END AS [Day]
        , CASE [Time] WHEN '-' THEN 'TBD' ELSE [Time] END AS [Time]
        , CASE [Enrolled] WHEN '' THEN 'TBD' ELSE [Enrolled] END AS [Enrolled]
        , CASE [Limit] WHEN '' THEN 'TBD' ELSE [Limit] END AS [Limit]
        , course.CourseID
        , mode.ModeOfInstructionID
        , room.RoomID
        , i.InstructorID
        , 'Quintero'
        , 'Andres'
        , 'Andres.Quintero71@qmail.cuny.edu'
        , 71
    FROM QueensClassScheduleSpring2019.Uploadfile.CoursesSpring2019

    INNER JOIN Project3.Course AS course
        ON course.CourseName = (LEFT([Course (hr, crd)], CHARINDEX(' ', [Course (hr, crd)], CHARINDEX(' ', [Course (hr, crd)]) + 1) - 1))
    
    
    INNER JOIN Project3.ModeOfInstruction AS mode
        ON mode.ModeType = [Mode of Instruction]
    
    
    INNER JOIN Project3.Room AS room
        ON CASE [Location] WHEN '' THEN 'TBD'
            ELSE SUBSTRING([Location], CHARINDEX(' ', [Location]) + 1, LEN([Location])) END
            = room.RoomNumber 
			AND (SELECT BuildingName 
				FROM Project3.Building
				 WHERE room.BuildingID = Building.BuildingID) =    CASE [Location] WHEN '' THEN 'TBD'
															ELSE LEFT([Location], CHARINDEX(' ', [Location]) - 1) END

    INNER JOIN Project3.Instructors AS i
        ON CASE [Instructor] WHEN '' THEN 'To be Determined To be Determined'
        ELSE CONCAT (
                InstructorLastname
                , ', '
                , InstructorFirstName
                )
                END
         = [Instructor]


    WHERE 
        [Course (hr, crd)] <> ' '
        AND [Enrolled] <= [Limit]
        AND [Mode of Instruction] <> ' '

END;
GO
-------------------------------------------------------------------------------------------------------------
-- =============================================
-- Author: Zihao Yin
-- Procedure: [Project3].[ShowTableStatusRowCount]
-- Create date: 3/28/2020
-- Description: count the row
-- =============================================
CREATE
    OR

ALTER PROCEDURE [Project3].[ShowTableStatusRowCount]
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;
    BEGIN
        SELECT 
            TableName = 'Project3.Department',
            COUNT(*) AS Rows
        FROM [Project3].Department
        UNION
        SELECT 
            TableName = 'Project3.Course',
            COUNT(*) AS Rows
        FROM [Project3].Course
        UNION
        SELECT 
            TableName = 'Project3.Instructors',
            COUNT(*) AS Rows
        FROM [Project3].Instructors
        UNION
        SELECT 
            TableName = 'Project3.Building',
            COUNT(*) AS Rows
        FROM [Project3].Building
        UNION
        SELECT
            TableName = 'Project3.Room',
            COUNT(*) AS Rows
        FROM [Project3].Room
        UNION
        SELECT
            TableName = 'Project3.ModeOfInstruction',
            COUNT(*) AS Rows
        FROM [Project3].ModeOfInstruction
        UNION
        SELECT 
            TableName = 'Project3.Class',
            COUNT(*) AS Rows
        FROM [Project3].Class
        
    END;

END;
GO
