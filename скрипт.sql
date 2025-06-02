-- �������� ���� ������
CREATE DATABASE [VeterinaryClinic]
GO

USE [VeterinaryClinic]
GO

-- ������� �������������
CREATE TABLE [dbo].[Users](
    [user_id] [int] IDENTITY(1,1) NOT NULL,
    [username] [nvarchar](50) NOT NULL,
    [email] [nvarchar](100) NOT NULL,
    [password] [nvarchar](255) NOT NULL,
    [role] [nvarchar](10) NOT NULL,
    PRIMARY KEY CLUSTERED ([user_id] ASC)
    WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, 
          IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, 
          ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

-- ������� ��������
CREATE TABLE [dbo].[Clients](
    [client_id] [int] IDENTITY(1,1) NOT NULL,
    [user_id] [int] NULL,
    [name] [nvarchar](100) NULL,
    [phone] [nvarchar](15) NULL,
    [address] [nvarchar](200) NULL,
    [pet_name] [nvarchar](100) NULL,
    [pet_type] [nvarchar](50) NULL,
    PRIMARY KEY CLUSTERED ([client_id] ASC)
    WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, 
          IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, 
          ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

-- ������� ������
CREATE TABLE [dbo].[Doctors](
    [doctor_id] [int] IDENTITY(1,1) NOT NULL,
    [user_id] [int] NULL,
    [name] [nvarchar](100) NOT NULL,
    [specialization] [nvarchar](100) NOT NULL,
    [rating] [int] NOT NULL,
    [bio] [text] NULL,
    [photo_url] [nvarchar](255) NULL,
    PRIMARY KEY CLUSTERED ([doctor_id] ASC)
    WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, 
          IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, 
          ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

-- ������� �����
CREATE TABLE [dbo].[Services](
    [service_id] [int] IDENTITY(1,1) NOT NULL,
    [name] [nvarchar](100) NOT NULL,
    [description] [text] NULL,
    [specialization] [nvarchar](100) NOT NULL,
    [duration_minutes] [int] NOT NULL DEFAULT 30,
    [price] [decimal](10, 2) NULL,
    PRIMARY KEY CLUSTERED ([service_id] ASC)
    WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, 
          IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, 
          ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

-- ������� ���������� ������
CREATE TABLE [dbo].[DoctorSchedules](
    [schedule_id] [int] IDENTITY(1,1) NOT NULL,
    [doctor_id] [int] NOT NULL,
    [day_of_week] [tinyint] NOT NULL, -- 1=�����������, ..., 7=�����������
    [start_time] [time](7) NOT NULL,
    [end_time] [time](7) NOT NULL,
    [is_working_day] [bit] NOT NULL DEFAULT 1,
    PRIMARY KEY CLUSTERED ([schedule_id] ASC)
    WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, 
          IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, 
          ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

-- ������� ����������
CREATE TABLE [dbo].[Appointments](
    [appointment_id] [int] IDENTITY(1,1) NOT NULL,
    [client_id] [int] NULL,
    [doctor_id] [int] NULL,
    [service_id] [int] NULL,
    [status] [nvarchar](20) NULL,
    [date] [date] NOT NULL,
    [time] [time](7) NOT NULL,
    [notes] [text] NULL,
    [diagnosis] [text] NULL,
    [prescription] [text] NULL,
    PRIMARY KEY CLUSTERED ([appointment_id] ASC)
    WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, 
          IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, 
          ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

-- ������� �������
CREATE TABLE [dbo].[Reviews](
    [review_id] [int] IDENTITY(1,1) NOT NULL,
    [doctor_id] [int] NULL,
    [client_id] [int] NULL,
    [appointment_id] [int] NULL,
    [rating] [int] NULL,
    [comment] [text] NULL,
    [created_at] [datetime] NOT NULL DEFAULT GETDATE(),
    PRIMARY KEY CLUSTERED ([review_id] ASC)
    WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, 
          IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, 
          ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

-- ������� �����
CREATE TABLE [dbo].[Logs](
    [log_id] [int] IDENTITY(1,1) NOT NULL,
    [user_id] [int] NULL,
    [action] [text] NOT NULL,
    [timestamp] [datetime] NULL DEFAULT GETDATE(),
    [ip_address] [nvarchar](50) NULL,
    PRIMARY KEY CLUSTERED ([log_id] ASC)
    WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, 
          IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, 
          ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

-- �������� ��������
CREATE UNIQUE NONCLUSTERED INDEX [IX_Users_Email] ON [dbo].[Users]([email] ASC)
GO

CREATE UNIQUE NONCLUSTERED INDEX [IX_Users_Username] ON [dbo].[Users]([username] ASC)
GO

CREATE INDEX [IX_Appointments_ClientId] ON [dbo].[Appointments]([client_id] ASC)
GO

CREATE INDEX [IX_Appointments_DoctorId] ON [dbo].[Appointments]([doctor_id] ASC)
GO

CREATE INDEX [IX_Appointments_Date] ON [dbo].[Appointments]([date] ASC)
GO

CREATE INDEX [IX_DoctorSchedules_DoctorId] ON [dbo].[DoctorSchedules]([doctor_id] ASC)
GO

-- �������� ����������� ������� ������
ALTER TABLE [dbo].[Clients] WITH CHECK ADD CONSTRAINT [FK_Clients_Users] 
FOREIGN KEY([user_id]) REFERENCES [dbo].[Users] ([user_id])
GO

ALTER TABLE [dbo].[Doctors] WITH CHECK ADD CONSTRAINT [FK_Doctors_Users] 
FOREIGN KEY([user_id]) REFERENCES [dbo].[Users] ([user_id])
GO

ALTER TABLE [dbo].[DoctorSchedules] WITH CHECK ADD CONSTRAINT [FK_DoctorSchedules_Doctors] 
FOREIGN KEY([doctor_id]) REFERENCES [dbo].[Doctors] ([doctor_id])
ON DELETE CASCADE
GO

ALTER TABLE [dbo].[Appointments] WITH CHECK ADD CONSTRAINT [FK_Appointments_Clients] 
FOREIGN KEY([client_id]) REFERENCES [dbo].[Clients] ([client_id])
GO

ALTER TABLE [dbo].[Appointments] WITH CHECK ADD CONSTRAINT [FK_Appointments_Doctors] 
FOREIGN KEY([doctor_id]) REFERENCES [dbo].[Doctors] ([doctor_id])
GO

ALTER TABLE [dbo].[Appointments] WITH CHECK ADD CONSTRAINT [FK_Appointments_Services] 
FOREIGN KEY([service_id]) REFERENCES [dbo].[Services] ([service_id])
GO

ALTER TABLE [dbo].[Reviews] WITH CHECK ADD CONSTRAINT [FK_Reviews_Doctors] 
FOREIGN KEY([doctor_id]) REFERENCES [dbo].[Doctors] ([doctor_id])
GO

ALTER TABLE [dbo].[Reviews] WITH CHECK ADD CONSTRAINT [FK_Reviews_Clients] 
FOREIGN KEY([client_id]) REFERENCES [dbo].[Clients] ([client_id])
GO

ALTER TABLE [dbo].[Reviews] WITH CHECK ADD CONSTRAINT [FK_Reviews_Appointments] 
FOREIGN KEY([appointment_id]) REFERENCES [dbo].[Appointments] ([appointment_id])
GO

ALTER TABLE [dbo].[Logs] WITH CHECK ADD CONSTRAINT [FK_Logs_Users] 
FOREIGN KEY([user_id]) REFERENCES [dbo].[Users] ([user_id])
GO

-- �������� ����������� �����������
ALTER TABLE [dbo].[Users] WITH CHECK ADD CONSTRAINT [CK_Users_Role] 
CHECK (([role]='�����' OR [role]='����' OR [role]='������'))
GO

ALTER TABLE [dbo].[Appointments] WITH CHECK ADD CONSTRAINT [CK_Appointments_Status] 
CHECK (([status]='��������' OR [status]='���������' OR [status]='�������������' OR [status]='����������'))
GO

ALTER TABLE [dbo].[Reviews] WITH CHECK ADD CONSTRAINT [CK_Reviews_Rating] 
CHECK (([rating]>=(1) AND [rating]<=(5)))
GO

ALTER TABLE [dbo].[DoctorSchedules] WITH CHECK ADD CONSTRAINT [CK_DoctorSchedules_DayOfWeek] 
CHECK (([day_of_week]>=(1) AND [day_of_week]<=(7)))
GO

ALTER TABLE [dbo].[DoctorSchedules] WITH CHECK ADD CONSTRAINT [CK_DoctorSchedules_Time] 
CHECK (([end_time]>[start_time]))
GO

ALTER TABLE [dbo].[Services] WITH CHECK ADD CONSTRAINT [CK_Services_Duration] 
CHECK (([duration_minutes]>(0)))
GO

-- ������� ��������� ������
-- ������������
SET IDENTITY_INSERT [dbo].[Users] ON
INSERT INTO [dbo].[Users] ([user_id], [username], [email], [password], [role]) VALUES 
(1, 'admin', 'admin@clinic.com', 'AQAAAAIAAYagAAAAEPu57Sen44PbVwW0Mv2NxwVO6eHZNfLbDI2NA/49sOHYO1D2tqp1Xcz10TdLWeQGPA==', '�����'),
(2, 'doctor1', 'doctor1@clinic.com', 'AQAAAAIAAYagAAAAEPu57Sen44PbVwW0Mv2NxwVO6eHZNfLbDI2NA/49sOHYO1D2tqp1Xcz10TdLWeQGPA==', '����'),
(3, 'doctor2', 'doctor2@clinic.com', 'AQAAAAIAAYagAAAAEPu57Sen44PbVwW0Mv2NxwVO6eHZNfLbDI2NA/49sOHYO1D2tqp1Xcz10TdLWeQGPA==', '����'),
(4, 'client1', 'client1@example.com', 'AQAAAAIAAYagAAAAEPu57Sen44PbVwW0Mv2NxwVO6eHZNfLbDI2NA/49sOHYO1D2tqp1Xcz10TdLWeQGPA==', '������'),
(5, 'client2', 'client2@example.com', 'AQAAAAIAAYagAAAAEPu57Sen44PbVwW0Mv2NxwVO6eHZNfLbDI2NA/49sOHYO1D2tqp1Xcz10TdLWeQGPA==', '������')
SET IDENTITY_INSERT [dbo].[Users] OFF
GO

-- �������
SET IDENTITY_INSERT [dbo].[Clients] ON
INSERT INTO [dbo].[Clients] ([client_id], [user_id], [name], [phone], [address], [pet_name], [pet_type]) VALUES 
(1, 4, '���� ������', '1234567890', '��. ������, 10', '������', '���'),
(2, 5, '���� ������', '2345678901', '��. �������, 5', '�����', '������')
SET IDENTITY_INSERT [dbo].[Clients] OFF
GO

-- �����
SET IDENTITY_INSERT [dbo].[Doctors] ON
INSERT INTO [dbo].[Doctors] ([doctor_id], [user_id], [name], [specialization], [rating], [bio], [photo_url]) VALUES 
(1, 2, '������� �.�.', '��������', 4, '������� ���������-�������� � 10-������ ������', '/images/doctors/1.jpg'),
(2, 3, '������� �.�.', '������', 5, '���������� �� ������� ������������� ���������', '/images/doctors/2.jpg')
SET IDENTITY_INSERT [dbo].[Doctors] OFF
GO

-- ������
SET IDENTITY_INSERT [dbo].[Services] ON
INSERT INTO [dbo].[Services] ([service_id], [name], [description], [specialization], [duration_minutes], [price]) VALUES 
(1, '������������ ���������', '��������� ������ ���������', '��������', 30, 1500.00),
(2, '����������', '���������� �������� ����������', '��������', 20, 2000.00),
(3, '������������� ��������', '���������� �������������� �������������', '������', 120, 10000.00),
(4, '����������������� ������', '������ ������� ��� � �����', '����������', 30, 2500.00),
(5, '�������������� ������������', '��� ���������� �������', '���������', 45, 3500.00)
SET IDENTITY_INSERT [dbo].[Services] OFF
GO

-- ���������� ������
SET IDENTITY_INSERT [dbo].[DoctorSchedules] ON
INSERT INTO [dbo].[DoctorSchedules] ([schedule_id], [doctor_id], [day_of_week], [start_time], [end_time], [is_working_day]) VALUES 
(1, 1, 1, '09:00:00', '18:00:00', 1),
(2, 1, 2, '09:00:00', '18:00:00', 1),
(3, 1, 3, '09:00:00', '18:00:00', 1),
(4, 1, 4, '09:00:00', '18:00:00', 1),
(5, 1, 5, '09:00:00', '18:00:00', 1),
(6, 2, 1, '10:00:00', '19:00:00', 1),
(7, 2, 2, '10:00:00', '19:00:00', 1),
(8, 2, 3, '10:00:00', '19:00:00', 1),
(9, 2, 4, '10:00:00', '19:00:00', 1),
(10, 2, 5, '10:00:00', '19:00:00', 1),
(11, 2, 6, '10:00:00', '15:00:00', 1)
SET IDENTITY_INSERT [dbo].[DoctorSchedules] OFF
GO

-- ����������
SET IDENTITY_INSERT [dbo].[Appointments] ON
INSERT INTO [dbo].[Appointments] ([appointment_id], [client_id], [doctor_id], [service_id], [status], [date], [time], [notes]) VALUES 
(1, 1, 1, 1, '���������', '2023-05-01', '10:00:00', '�������� ������'),
(2, 2, 2, 3, '���������', '2023-05-02', '11:00:00', '�������� �� �������� �������'),
(3, 1, 1, 2, '�������������', '2023-06-01', '14:00:00', '�������� ����������')
SET IDENTITY_INSERT [dbo].[Appointments] OFF
GO

-- ������
SET IDENTITY_INSERT [dbo].[Reviews] ON
INSERT INTO [dbo].[Reviews] ([review_id], [doctor_id], [client_id], [appointment_id], [rating], [comment]) VALUES 
(1, 1, 1, 1, 5, '�������� ����, ��� �������� � �����'),
(2, 2, 2, 2, 4, '�������� ������ �������, �� ����� �����')
SET IDENTITY_INSERT [dbo].[Reviews] OFF
GO