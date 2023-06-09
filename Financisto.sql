USE [master]
GO
/****** Object:  Database [Financisto]    Script Date: 13/04/2023 12:25:39 JC ******/
CREATE DATABASE [Financisto]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'Financisto', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.SQLEXPRESS\MSSQL\DATA\Financisto.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'Financisto_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.SQLEXPRESS\MSSQL\DATA\Financisto_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO
ALTER DATABASE [Financisto] SET COMPATIBILITY_LEVEL = 150
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [Financisto].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [Financisto] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [Financisto] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [Financisto] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [Financisto] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [Financisto] SET ARITHABORT OFF 
GO
ALTER DATABASE [Financisto] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [Financisto] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [Financisto] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [Financisto] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [Financisto] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [Financisto] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [Financisto] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [Financisto] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [Financisto] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [Financisto] SET  DISABLE_BROKER 
GO
ALTER DATABASE [Financisto] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [Financisto] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [Financisto] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [Financisto] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [Financisto] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [Financisto] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [Financisto] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [Financisto] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [Financisto] SET  MULTI_USER 
GO
ALTER DATABASE [Financisto] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [Financisto] SET DB_CHAINING OFF 
GO
ALTER DATABASE [Financisto] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [Financisto] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [Financisto] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [Financisto] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
ALTER DATABASE [Financisto] SET QUERY_STORE = OFF
GO
USE [Financisto]
GO
/****** Object:  Table [dbo].[Account]    Script Date: 13/04/2023 12:25:39 JC ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Account](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[TypeId] [int] NULL,
	[Name] [nvarchar](300) NULL,
	[Currency] [nvarchar](50) NULL,
	[Amount] [decimal](18, 2) NULL,
	[ImagePath] [nvarchar](500) NULL,
	[UserId] [int] NULL,
	[CreditLimit] [decimal](18, 2) NULL,
 CONSTRAINT [PK_Account] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Categoria]    Script Date: 13/04/2023 12:25:40 JC ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Categoria](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Nombre] [nvarchar](100) NULL,
 CONSTRAINT [PK_Categoria] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Producto]    Script Date: 13/04/2023 12:25:40 JC ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Producto](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Nombre] [nvarchar](200) NULL,
	[IdCategoria] [int] NULL,
	[Proveedor] [nvarchar](200) NULL,
	[Costo] [decimal](18, 2) NULL,
 CONSTRAINT [PK_Producto] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Transaction]    Script Date: 13/04/2023 12:25:40 JC ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Transaction](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[CuentaId] [int] NULL,
	[Tipo] [nvarchar](100) NULL,
	[FechaHora] [datetime] NULL,
	[Motivo] [nvarchar](500) NULL,
	[Monto] [decimal](18, 5) NULL,
 CONSTRAINT [PK_Transaction] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Types]    Script Date: 13/04/2023 12:25:40 JC ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Types](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Nombre] [nvarchar](100) NULL,
 CONSTRAINT [PK_Types] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[User]    Script Date: 13/04/2023 12:25:40 JC ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[User](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Username] [nvarchar](100) NULL,
	[Password] [nvarchar](100) NULL,
 CONSTRAINT [PK_User] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[Account] ON 

INSERT [dbo].[Account] ([Id], [TypeId], [Name], [Currency], [Amount], [ImagePath], [UserId], [CreditLimit]) VALUES (35, 3, N'Tarjeta BCP Visa Latam', N'Soles', CAST(-250.00 AS Decimal(18, 2)), N'\files\course-2.jpg', 10, CAST(1000.00 AS Decimal(18, 2)))
INSERT [dbo].[Account] ([Id], [TypeId], [Name], [Currency], [Amount], [ImagePath], [UserId], [CreditLimit]) VALUES (36, 2, N'Sueldo Municipalidad de Baños', N'Soles', CAST(50.00 AS Decimal(18, 2)), N'\files\about2.jpg', 10, NULL)
INSERT [dbo].[Account] ([Id], [TypeId], [Name], [Currency], [Amount], [ImagePath], [UserId], [CreditLimit]) VALUES (37, 1, N'Billetera', N'Soles', CAST(146.50 AS Decimal(18, 2)), N'\files\car1-min2.jpg', 10, NULL)
INSERT [dbo].[Account] ([Id], [TypeId], [Name], [Currency], [Amount], [ImagePath], [UserId], [CreditLimit]) VALUES (40, 1, N'Chanchicho', N'Soles', CAST(500.00 AS Decimal(18, 2)), N'\files\about5-min2.jpg', 10, NULL)
INSERT [dbo].[Account] ([Id], [TypeId], [Name], [Currency], [Amount], [ImagePath], [UserId], [CreditLimit]) VALUES (42, 3, N'Caja Piura', N'Soles', CAST(-315.00 AS Decimal(18, 2)), N'\files\about4.jpg', 10, CAST(1000.00 AS Decimal(18, 2)))
INSERT [dbo].[Account] ([Id], [TypeId], [Name], [Currency], [Amount], [ImagePath], [UserId], [CreditLimit]) VALUES (1057, 1, N'dwdawdwa', N'Soles', CAST(123.00 AS Decimal(18, 2)), N'\files\car4-min2.jpg', 1, NULL)
SET IDENTITY_INSERT [dbo].[Account] OFF
GO
SET IDENTITY_INSERT [dbo].[Categoria] ON 

INSERT [dbo].[Categoria] ([Id], [Nombre]) VALUES (1, N'Laptops')
INSERT [dbo].[Categoria] ([Id], [Nombre]) VALUES (2, N'Impresoras')
INSERT [dbo].[Categoria] ([Id], [Nombre]) VALUES (3, N'Accesorios')
SET IDENTITY_INSERT [dbo].[Categoria] OFF
GO
SET IDENTITY_INSERT [dbo].[Producto] ON 

INSERT [dbo].[Producto] ([Id], [Nombre], [IdCategoria], [Proveedor], [Costo]) VALUES (1, N'Laptop Gamer i5 Ryzen', 1, N'Deltron', CAST(5400.00 AS Decimal(18, 2)))
INSERT [dbo].[Producto] ([Id], [Nombre], [IdCategoria], [Proveedor], [Costo]) VALUES (2, N'Impreso HP desk 5001', 2, N'Compupartes', CAST(780.00 AS Decimal(18, 2)))
INSERT [dbo].[Producto] ([Id], [Nombre], [IdCategoria], [Proveedor], [Costo]) VALUES (3, N'Memoria Usb HP 32 GB', 3, N'InfoTec', CAST(85.00 AS Decimal(18, 2)))
INSERT [dbo].[Producto] ([Id], [Nombre], [IdCategoria], [Proveedor], [Costo]) VALUES (5, N'Monitor LG', 1, N'InfoTec', CAST(780.00 AS Decimal(18, 2)))
INSERT [dbo].[Producto] ([Id], [Nombre], [IdCategoria], [Proveedor], [Costo]) VALUES (6, N'Audifonos Halin Gamer 570', 3, N'Linio Tec', CAST(50.00 AS Decimal(18, 2)))
INSERT [dbo].[Producto] ([Id], [Nombre], [IdCategoria], [Proveedor], [Costo]) VALUES (13, N'MousePad Gamer XD', 3, N'InfoTec', CAST(50.00 AS Decimal(18, 2)))
INSERT [dbo].[Producto] ([Id], [Nombre], [IdCategoria], [Proveedor], [Costo]) VALUES (14, N'HTML 5 xd', 2, N'InfoTec xd', CAST(20.00 AS Decimal(18, 2)))
SET IDENTITY_INSERT [dbo].[Producto] OFF
GO
SET IDENTITY_INSERT [dbo].[Transaction] ON 

INSERT [dbo].[Transaction] ([Id], [CuentaId], [Tipo], [FechaHora], [Motivo], [Monto]) VALUES (92, 35, N'Gasto', CAST(N'2023-03-28T22:08:00.000' AS DateTime), N'Zapatillas Adidas', CAST(-200.00000 AS Decimal(18, 5)))
INSERT [dbo].[Transaction] ([Id], [CuentaId], [Tipo], [FechaHora], [Motivo], [Monto]) VALUES (93, 36, N'Ingreso', CAST(N'2023-03-28T22:20:10.723' AS DateTime), N'Monto Inicial', CAST(500.00000 AS Decimal(18, 5)))
INSERT [dbo].[Transaction] ([Id], [CuentaId], [Tipo], [FechaHora], [Motivo], [Monto]) VALUES (94, 37, N'Ingreso', CAST(N'2023-03-28T22:26:01.217' AS DateTime), N'Monto Inicial', CAST(150.00000 AS Decimal(18, 5)))
INSERT [dbo].[Transaction] ([Id], [CuentaId], [Tipo], [FechaHora], [Motivo], [Monto]) VALUES (95, 37, N'Gasto', CAST(N'2023-03-28T22:27:00.000' AS DateTime), N'Helado de Chicha', CAST(-3.50000 AS Decimal(18, 5)))
INSERT [dbo].[Transaction] ([Id], [CuentaId], [Tipo], [FechaHora], [Motivo], [Monto]) VALUES (96, 35, N'Ingreso', CAST(N'2023-03-28T22:29:00.000' AS DateTime), N'Pague gasto de la tarjeta', CAST(200.00000 AS Decimal(18, 5)))
INSERT [dbo].[Transaction] ([Id], [CuentaId], [Tipo], [FechaHora], [Motivo], [Monto]) VALUES (97, 35, N'Gasto', CAST(N'2023-03-29T13:30:00.000' AS DateTime), N'Casaca NorthFace', CAST(-1000.00000 AS Decimal(18, 5)))
INSERT [dbo].[Transaction] ([Id], [CuentaId], [Tipo], [FechaHora], [Motivo], [Monto]) VALUES (98, 35, N'Ingreso', CAST(N'2023-03-29T13:37:00.000' AS DateTime), N'Pago de Tarjeta', CAST(1000.00000 AS Decimal(18, 5)))
INSERT [dbo].[Transaction] ([Id], [CuentaId], [Tipo], [FechaHora], [Motivo], [Monto]) VALUES (99, 35, N'Gasto', CAST(N'2023-03-29T14:14:00.000' AS DateTime), N'Zapatillas Adidas', CAST(-1000.00000 AS Decimal(18, 5)))
INSERT [dbo].[Transaction] ([Id], [CuentaId], [Tipo], [FechaHora], [Motivo], [Monto]) VALUES (100, 35, N'Ingreso', CAST(N'2023-03-29T14:15:00.000' AS DateTime), N'Pague tarjeta', CAST(1000.00000 AS Decimal(18, 5)))
INSERT [dbo].[Transaction] ([Id], [CuentaId], [Tipo], [FechaHora], [Motivo], [Monto]) VALUES (101, 35, N'Gasto', CAST(N'2023-03-29T14:17:00.000' AS DateTime), N'Compre medias', CAST(-20.00000 AS Decimal(18, 5)))
INSERT [dbo].[Transaction] ([Id], [CuentaId], [Tipo], [FechaHora], [Motivo], [Monto]) VALUES (102, 35, N'Gasto', CAST(N'2023-03-29T14:18:00.000' AS DateTime), N'Compre zapatillas gzuck', CAST(-200.00000 AS Decimal(18, 5)))
INSERT [dbo].[Transaction] ([Id], [CuentaId], [Tipo], [FechaHora], [Motivo], [Monto]) VALUES (103, 40, N'Ingreso', CAST(N'2023-04-07T01:22:48.933' AS DateTime), N'Monto Inicial', CAST(500.00000 AS Decimal(18, 5)))
INSERT [dbo].[Transaction] ([Id], [CuentaId], [Tipo], [FechaHora], [Motivo], [Monto]) VALUES (104, 41, N'Ingreso', CAST(N'2023-04-07T01:29:35.093' AS DateTime), N'Monto Inicial', CAST(500.00000 AS Decimal(18, 5)))
INSERT [dbo].[Transaction] ([Id], [CuentaId], [Tipo], [FechaHora], [Motivo], [Monto]) VALUES (105, 41, N'Gasto', CAST(N'2023-04-07T01:30:00.000' AS DateTime), N'Zapatillas Adidas', CAST(-250.00000 AS Decimal(18, 5)))
INSERT [dbo].[Transaction] ([Id], [CuentaId], [Tipo], [FechaHora], [Motivo], [Monto]) VALUES (106, 42, N'Gasto', CAST(N'2023-04-10T21:35:00.000' AS DateTime), N'Zapatillas Adidas Talla 42', CAST(-310.00000 AS Decimal(18, 5)))
INSERT [dbo].[Transaction] ([Id], [CuentaId], [Tipo], [FechaHora], [Motivo], [Monto]) VALUES (1103, 1039, N'Ingreso', CAST(N'2023-04-10T22:13:09.993' AS DateTime), N'Monto Inicial', CAST(200.00000 AS Decimal(18, 5)))
INSERT [dbo].[Transaction] ([Id], [CuentaId], [Tipo], [FechaHora], [Motivo], [Monto]) VALUES (1104, 1041, N'Ingreso', CAST(N'2023-04-10T22:34:50.777' AS DateTime), N'Monto Inicial', CAST(25.00000 AS Decimal(18, 5)))
INSERT [dbo].[Transaction] ([Id], [CuentaId], [Tipo], [FechaHora], [Motivo], [Monto]) VALUES (1105, 1044, N'Ingreso', CAST(N'2023-04-11T11:29:18.590' AS DateTime), N'Monto Inicial', CAST(1500.00000 AS Decimal(18, 5)))
INSERT [dbo].[Transaction] ([Id], [CuentaId], [Tipo], [FechaHora], [Motivo], [Monto]) VALUES (1106, 1045, N'Ingreso', CAST(N'2023-04-11T11:48:56.727' AS DateTime), N'Monto Inicial', CAST(1500.00000 AS Decimal(18, 5)))
INSERT [dbo].[Transaction] ([Id], [CuentaId], [Tipo], [FechaHora], [Motivo], [Monto]) VALUES (1107, 1047, N'Ingreso', CAST(N'2023-04-11T12:32:18.800' AS DateTime), N'Monto Inicial', CAST(45.00000 AS Decimal(18, 5)))
INSERT [dbo].[Transaction] ([Id], [CuentaId], [Tipo], [FechaHora], [Motivo], [Monto]) VALUES (1108, 1048, N'Ingreso', CAST(N'2023-04-11T12:48:57.497' AS DateTime), N'Monto Inicial', CAST(1500.00000 AS Decimal(18, 5)))
INSERT [dbo].[Transaction] ([Id], [CuentaId], [Tipo], [FechaHora], [Motivo], [Monto]) VALUES (1109, 1050, N'Ingreso', CAST(N'2023-04-11T18:20:05.743' AS DateTime), N'Monto Inicial', CAST(150.00000 AS Decimal(18, 5)))
INSERT [dbo].[Transaction] ([Id], [CuentaId], [Tipo], [FechaHora], [Motivo], [Monto]) VALUES (1110, 35, N'Gasto', CAST(N'2023-04-08T14:00:00.000' AS DateTime), N'Calzoncillos Espartano', CAST(-30.00000 AS Decimal(18, 5)))
INSERT [dbo].[Transaction] ([Id], [CuentaId], [Tipo], [FechaHora], [Motivo], [Monto]) VALUES (1111, 1051, N'Ingreso', CAST(N'2023-04-11T21:22:43.530' AS DateTime), N'Monto Inicial', CAST(500.00000 AS Decimal(18, 5)))
INSERT [dbo].[Transaction] ([Id], [CuentaId], [Tipo], [FechaHora], [Motivo], [Monto]) VALUES (1112, 1052, N'Ingreso', CAST(N'2023-04-11T22:38:40.930' AS DateTime), N'Monto Inicial', CAST(500.00000 AS Decimal(18, 5)))
INSERT [dbo].[Transaction] ([Id], [CuentaId], [Tipo], [FechaHora], [Motivo], [Monto]) VALUES (1113, 42, N'Gasto', CAST(N'2023-04-11T22:39:00.000' AS DateTime), N'Salchipollo', CAST(-5.00000 AS Decimal(18, 5)))
INSERT [dbo].[Transaction] ([Id], [CuentaId], [Tipo], [FechaHora], [Motivo], [Monto]) VALUES (1114, 36, N'Gasto', CAST(N'2023-04-11T22:44:00.000' AS DateTime), N'Compre anillo de compromiso', CAST(-500.00000 AS Decimal(18, 5)))
INSERT [dbo].[Transaction] ([Id], [CuentaId], [Tipo], [FechaHora], [Motivo], [Monto]) VALUES (1115, 36, N'Ingreso', CAST(N'2023-04-11T22:45:00.000' AS DateTime), N'Deposito de mi vida bonita', CAST(50.00000 AS Decimal(18, 5)))
INSERT [dbo].[Transaction] ([Id], [CuentaId], [Tipo], [FechaHora], [Motivo], [Monto]) VALUES (1116, 1053, N'Ingreso', CAST(N'2023-04-11T22:59:56.710' AS DateTime), N'Monto Inicial', CAST(800.00000 AS Decimal(18, 5)))
INSERT [dbo].[Transaction] ([Id], [CuentaId], [Tipo], [FechaHora], [Motivo], [Monto]) VALUES (1117, 1054, N'Ingreso', CAST(N'2023-04-11T23:00:42.170' AS DateTime), N'Monto Inicial', CAST(25.00000 AS Decimal(18, 5)))
INSERT [dbo].[Transaction] ([Id], [CuentaId], [Tipo], [FechaHora], [Motivo], [Monto]) VALUES (1118, 38, N'Gasto', CAST(N'2023-04-04T10:00:00.000' AS DateTime), N'Salchipollo', CAST(-5.00000 AS Decimal(18, 5)))
INSERT [dbo].[Transaction] ([Id], [CuentaId], [Tipo], [FechaHora], [Motivo], [Monto]) VALUES (1119, 1056, N'Ingreso', CAST(N'2023-04-12T13:36:23.293' AS DateTime), N'Monto Inicial', CAST(5000.00000 AS Decimal(18, 5)))
INSERT [dbo].[Transaction] ([Id], [CuentaId], [Tipo], [FechaHora], [Motivo], [Monto]) VALUES (1120, 1057, N'Ingreso', CAST(N'2023-04-12T13:42:32.647' AS DateTime), N'Monto Inicial', CAST(123.00000 AS Decimal(18, 5)))
INSERT [dbo].[Transaction] ([Id], [CuentaId], [Tipo], [FechaHora], [Motivo], [Monto]) VALUES (1121, 1058, N'Ingreso', CAST(N'2023-04-12T20:55:01.353' AS DateTime), N'Monto Inicial', CAST(15.00000 AS Decimal(18, 5)))
SET IDENTITY_INSERT [dbo].[Transaction] OFF
GO
SET IDENTITY_INSERT [dbo].[Types] ON 

INSERT [dbo].[Types] ([Id], [Nombre]) VALUES (1, N'Efectivo')
INSERT [dbo].[Types] ([Id], [Nombre]) VALUES (2, N'Débito')
INSERT [dbo].[Types] ([Id], [Nombre]) VALUES (3, N'Crédito')
SET IDENTITY_INSERT [dbo].[Types] OFF
GO
SET IDENTITY_INSERT [dbo].[User] ON 

INSERT [dbo].[User] ([Id], [Username], [Password]) VALUES (1, N'admin', N'i/aq7xOGzB1pCj0AP8Xi6hAjnkBjSnVqTc/GBrXjx0s=')
INSERT [dbo].[User] ([Id], [Username], [Password]) VALUES (2, N'admin2', N'i/aq7xOGzB1pCj0AP8Xi6hAjnkBjSnVqTc/GBrXjx0s=')
INSERT [dbo].[User] ([Id], [Username], [Password]) VALUES (10, N'jhan24', N'l5dL/Qdzr4+yI9gmYN5HG/LLy6YUIvwOVjhZCckbXHo=')
INSERT [dbo].[User] ([Id], [Username], [Password]) VALUES (16, N'hola', N'hLxXrvZQ5YD1Ofc3kA4joOjJTFLeFnW3EhpIsD86x5Q=')
INSERT [dbo].[User] ([Id], [Username], [Password]) VALUES (1016, N'angie', N'p9oWt/WcRdCMVf4NtsrzGYfON+cg0kqLreiKnu2oahM=')
INSERT [dbo].[User] ([Id], [Username], [Password]) VALUES (1017, N'juli', N'UxwbUiY3KOsAu89xKOiINg/2VBOxycYnRDhGOSk41n4=')
INSERT [dbo].[User] ([Id], [Username], [Password]) VALUES (1018, N'julia12', N'5c80nZV8QHhD3r6xbMHYOLQ7z09YU95iHdNn0Nopdpg=')
INSERT [dbo].[User] ([Id], [Username], [Password]) VALUES (1019, N'yola', N'Ja0IC7RMVCNvId72001yUu5rffxaD5M8Bldy+02v3tM=')
INSERT [dbo].[User] ([Id], [Username], [Password]) VALUES (1020, N'yola', N'Ja0IC7RMVCNvId72001yUu5rffxaD5M8Bldy+02v3tM=')
INSERT [dbo].[User] ([Id], [Username], [Password]) VALUES (1021, N'yola', N'Ja0IC7RMVCNvId72001yUu5rffxaD5M8Bldy+02v3tM=')
INSERT [dbo].[User] ([Id], [Username], [Password]) VALUES (1022, NULL, N'0aY5YCKxduXZLfDOuznQJM3WYWsKgzPvityO0cKvqmo=')
INSERT [dbo].[User] ([Id], [Username], [Password]) VALUES (1023, N'holajaja', N'hLxXrvZQ5YD1Ofc3kA4joOjJTFLeFnW3EhpIsD86x5Q=')
INSERT [dbo].[User] ([Id], [Username], [Password]) VALUES (1024, N'jajaja', N'vlspMpwshoGgQr3lj3un/b1a6W61GCn30J1Ek0+sxmk=')
SET IDENTITY_INSERT [dbo].[User] OFF
GO
USE [master]
GO
ALTER DATABASE [Financisto] SET  READ_WRITE 
GO
