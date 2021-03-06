CREATE TABLE IF NOT EXISTS users (
	Id int(20) PRIMARY KEY AUTO_INCREMENT,
    Name varchar(255),
    Photo varchar(255) NOT NULL,
    CreateDate datetime DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS projects (
	Id int(20) PRIMARY KEY AUTO_INCREMENT,
    Name varchar(255) NOT NULL,
    GitHubLink varchar(255) NOT NULL,
    ClientContact varchar(255) NOT NULL,
    File varchar(255) NULL,
    Type ENUM('landing', 'card', 'e-shop', 'info-portal', 'business-portal') DEFAULT 'landing',
    Status ENUM('planning', 'active', 'testing', 'frozen', 'closed') DEFAULT 'planning',
    ClientLink varchar(255) NULL,
    CreateUserId int(20) NOT NULL,
    CreateDate datetime DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT project_user_fk FOREIGN KEY(CreateUserId) REFERENCES users(Id) ON DELETE RESTRICT
);

CREATE TABLE IF NOT EXISTS roles (
	Id int(20) PRIMARY KEY AUTO_INCREMENT,
    Name varchar(255) NOT NULL,
    CreateDate datetime DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS projectusers (
    Id int(20) PRIMARY KEY AUTO_INCREMENT,
	UserId int(20) NOT NULL,
    ProjectId int(20) NOT NULL,
    CreateDate datetime DEFAULT CURRENT_TIMESTAMP,
    Roles SET ('teamlead', 'clientmanager', 'designer', 'developer', 'tester') NOT NULL,

    CONSTRAINT projectuser_user_fk FOREIGN KEY(UserId) REFERENCES users(Id) ON DELETE RESTRICT,
    CONSTRAINT projectuser_project_fk FOREIGN KEY(ProjectId) REFERENCES projects(Id) ON DELETE CASCADE,
    UNIQUE(UserId, ProjectId)
    
);


CREATE TABLE IF NOT EXISTS tasks (
	Id int(20) PRIMARY KEY AUTO_INCREMENT,
    Name varchar(255) NOT NULL,
    ProjectId int(20) NOT NULL,
    UserId int(20) NOT NULL,
    RequirementId int(20) NULL,
    Description text NOT NULL,
    PlanTime int(4) NULL,
    FactTime int(4) NULL,
    Type ENUM('task', 'bug', 'requirement'),
    Status ENUM('proposed', 'active', 'resolved', 'testing', 'closed'),
    Priority ENUM('critical', 'high', 'medium', 'low'),
    CreateUserId int(20) NOT NULL,
    CreateDate datetime DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT t_user_fk FOREIGN KEY(CreateUserId) REFERENCES users(Id) ON DELETE RESTRICT,
    CONSTRAINT t_u_fk FOREIGN KEY(UserId) REFERENCES users(Id) ON DELETE RESTRICT,
    CONSTRAINT t_project_fk FOREIGN KEY(ProjectId) REFERENCES projects(Id) ON DELETE CASCADE,
    CONSTRAINT t_requirement_fk FOREIGN KEY(RequirementId) REFERENCES tasks(Id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS links (
	ParentId int(20) NOT NULL,
    ChildId int(20) NOT NULL,
    CreateDate datetime DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT links_task_fk FOREIGN KEY(ParentId) REFERENCES tasks(Id) ON DELETE CASCADE,
    CONSTRAINT links_t_fk FOREIGN KEY(ChildId) REFERENCES tasks(Id) ON DELETE CASCADE,
    CONSTRAINT links_pk PRIMARY KEY(ParentId, ChildId)
    
);

CREATE TABLE IF NOT EXISTS files (
    Id int(20) PRIMARY KEY AUTO_INCREMENT,
	Name varchar(255) NOT NULL,
    OwnerId int(20) NOT NULL,
    CreateDate datetime DEFAULT CURRENT_TIMESTAMP,
    Type ENUM('task', 'project', 'message') NOT NULL,
    Path varchar(255) NOT NULL,
    Size float(10,2) NULL,
    
    INDEX(OwnerId, Type)
    
);

CREATE TABLE IF NOT EXISTS messages (
	Id int(20) PRIMARY KEY AUTO_INCREMENT,
    TaskId int(20) NOT NULL,
    UserId int(20) NOT NULL,
    Text text NOT NULL,
    CreateDate datetime DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT messages_task_fk FOREIGN KEY(TaskId) REFERENCES tasks(Id) ON DELETE CASCADE,
    CONSTRAINT messages_users_fk FOREIGN KEY(UserId) REFERENCES users(Id) ON DELETE CASCADE
    
);