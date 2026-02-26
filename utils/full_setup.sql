- Drop old database if exists and create new one
DROP DATABASE IF EXISTS ccsprint;
CREATE DATABASE ccsprint;
USE ccsprint;

-- Create tables
CREATE TABLE `events` (
    `id` VARCHAR(50) PRIMARY KEY,
    `title` VARCHAR(255) NOT NULL,
    `date` DATE NOT NULL,
    `time` VARCHAR(50),
    `location` VARCHAR(100),
    `description` TEXT,
    `category` VARCHAR(50)
);

CREATE TABLE `attendees` (
    `id` VARCHAR(50) PRIMARY KEY,
    `firstName` VARCHAR(50) NOT NULL,
    `lastName` VARCHAR(50) NOT NULL,
    `email` VARCHAR(100) NOT NULL,
    `avatar` VARCHAR(255),
    `phone` VARCHAR(20),
    `role` VARCHAR(50),
    `reasonForAttending` VARCHAR(255)
);

CREATE TABLE `attendee_events` (
    `attendee_id` VARCHAR(50),
    `event_id` VARCHAR(50),
    PRIMARY KEY(`attendee_id`, `event_id`),
    FOREIGN KEY(`attendee_id`) REFERENCES `attendees`(`id`) ON DELETE CASCADE,
    FOREIGN KEY(`event_id`) REFERENCES `events`(`id`) ON DELETE CASCADE
);

-- Insert all events
INSERT INTO `events` (`id`, `title`, `date`, `time`, `location`, `description`, `category`) VALUES
('e41c542f-4e9a-4ee8-badb-06090d10df36','Product Launch Strategy Bootcamp','2025-06-20','7:00-9:00 PM','New York','Dive into product launch strategies and go-to-market playbooks with top industry leaders.','Product'),
('95335c2a-c9d4-40da-ad59-6488f993a0d8','Roadmapping & MVP Design','2025-06-21','7:00-9:00 PM','Los Angeles','Learn how to define, prioritize, and build minimum viable products that customers love.','Product'),
('e1ea5ebe-8a22-4bf6-b91d-4d7353c1d02c','AI in Real Life: Practical Applications','2025-06-22','7:00-9:00 PM','Chicago','Explore real-world AI use cases across industries, from automation to personalization.','AI'),
('c5b88ab5-c8c4-4e7f-8344-458ec32bbf29','Neural Networks & Deep Learning Summit','2025-06-23','7:00-9:00 PM','Houston','A deep dive into neural networks, model tuning, and future trends in deep learning.','AI'),
('21d5baa2-ef1e-4bc1-a879-d5f3cd2d6b96','Design Thinking for Innovation','2025-06-24','7:00-9:00 PM','Phoenix','Master the human-centered approach to solving complex problems through design thinking.','Design'),
('24811b5d-2f7b-4dc7-aa5c-44dd9f17fa17','Data Science for Decision Making','2025-06-25','7:00-9:00 PM','San Francisco','Harness the power of data to drive actionable insights and strategic decisions.','Data Science'),
('d6564e74-7f3d-4777-aeb7-81b18d4a2fee','Cyber Security Essentials Workshop','2025-06-26','7:00-9:00 PM','San Francisco','Learn how to identify threats, protect assets, and respond to security breaches effectively.','Cyber Security'),
('80de41c8-f689-4c20-8276-1dab81e8f909','Building Scalable Software Systems','2025-06-27','7:00-9:00 PM','San Francisco','Design and build maintainable, scalable software architectures using modern practices.','Software'),
('68edd79d-27d5-4477-bba9-6b5cb93fcfe9','Intro to Prompt Engineering','2025-06-28','7:00-9:00 PM','Austin','Understand how to craft effective prompts for AI tools like ChatGPT and improve outcomes.','AI'),
('ffb22e67-bc7f-4f41-8e44-2989cdf57ba5','UX Research Fundamentals','2025-06-29','7:00-9:00 PM','Seattle','Learn how to conduct user research that informs design and improves usability.','Design'),
('c6b37724-4f12-4a4a-97db-90c1b13992ba','Effective Stakeholder Communication','2025-06-30','7:00-9:00 PM','Boston','Master the art of clear, concise, and influential communication with cross-functional teams.','Product'),
('3432d42a-7e86-4a3d-8376-653e412f29d0','Web3 & Blockchain Development','2025-07-01','7:00-9:00 PM','Miami','Dive into the world of decentralized apps, smart contracts, and blockchain protocols.','Software'),
('117175ca-924c-4a33-8843-f13d5c4c2c75','Advanced Data Visualization','2025-07-02','7:00-9:00 PM','Denver','Tell compelling data stories through interactive dashboards and modern visualization tools.','Data Science'),
('5d4321b4-f864-4b29-963f-53cf292d06af','Cloud Infrastructure Bootcamp','2025-07-03','7:00-9:00 PM','Portland','Get hands-on experience with deploying scalable infrastructure using AWS, Azure, and GCP.','Software'),
('d3849566-f81f-4739-a921-97141964dd6e','Agile Methodologies in Practice','2025-07-04','7:00-9:00 PM','Philadelphia','Explore Scrum, Kanban, and hybrid models to improve team productivity and adaptability.','Product'),
('a9cabe73-6792-4002-a704-ad30db7f60d1','Intro to Ethical AI','2025-07-05','7:00-9:00 PM','Atlanta','Learn the principles of fairness, transparency, and accountability in AI systems.','AI'),
('4cf92645-24d1-432f-8fcd-31840bc04ef6','Mobile App Design Patterns','2025-07-06','7:00-9:00 PM','San Diego','Design beautiful and functional mobile apps with best practices in UI/UX patterns.','Design'),
('d7bc75ee-9150-4338-bef2-f836511248bf','Intro to SQL & Relational Databases','2025-07-07','7:00-9:00 PM','Dallas','Get started with writing SQL queries, understanding joins, and designing relational schemas.','Data Science');

-- Insert all attendees
INSERT INTO `attendees` (`id`, `firstName`, `lastName`, `email`, `avatar`, `phone`, `role`, `reasonForAttending`) VALUES
('8f819e96-b42d-41ec-a5ea-d42b6f245e0d','Amaury','Dumas','amaury@example.com','https://unit-3-api-6b6268be0363.herokuapp.com/avatars/8f819e96-b42d-41ec-a5ea-d42b6f245e0d.jpg','555-555-0101','senior developer','Networking'),
('4cb928d2-9853-45c5-bd93-5c37741e567a','Sofia','Martinez','sofia.martinez@example.com','https://unit-3-api-6b6268be0363.herokuapp.com/avatars/4cb928d2-9853-45c5-bd93-5c37741e567a.jpg','555-555-0102','frontend developer','Professional development'),
('98d6a02c-c101-4473-9a07-337b5d67c31a','Liam','Chen','liam.chen@example.com','https://unit-3-api-6b6268be0363.herokuapp.com/avatars/98d6a02c-c101-4473-9a07-337b5d67c31a.jpg','555-555-0103','full stack developer','Job searching'),
('c45c9284-6299-475a-bd51-1a0f16782b29','Aisha','Khan','aisha.khan@example.com','https://unit-3-api-6b6268be0363.herokuapp.com/avatars/c45c9284-6299-475a-bd51-1a0f16782b29.jpg','555-555-0104','backend developer','Networking'),
('6ff8dfc3-d1ca-4602-88a1-ebf355e35ef0','Noah','Nguyen','noah.nguyen@example.com','https://unit-3-api-6b6268be0363.herokuapp.com/avatars/6ff8dfc3-d1ca-4602-88a1-ebf355e35ef0.jpg','555-555-0105','devops engineer','Just for fun'),
('7d7ae252-a724-4cbd-98d9-4b18f93d5a0a','Chloe','Dubois','chloe.dubois@example.com','https://unit-3-api-6b6268be0363.herokuapp.com/avatars/7d7ae252-a724-4cbd-98d9-4b18f93d5a0a.jpg','555-555-0106','ui/ux designer','Professional development'),
('c968b861-f8ab-4d33-bf72-530db6a4d476','Ethan','Okafor','ethan.okafor@example.com','https://unit-3-api-6b6268be0363.herokuapp.com/avatars/c968b861-f8ab-4d33-bf72-530db6a4d476.jpg','555-555-0107','junior developer','Job searching'),
('1ad2a80a-283e-480a-bf6c-bee28427a052','Maya','Singh','maya.singh@example.com','https://unit-3-api-6b6268be0363.herokuapp.com/avatars/1ad2a80a-283e-480a-bf6c-bee28427a052.jpg','555-555-0108','product manager','Networking'),
('b835f6db-9340-4458-ae15-ea382ccc5c7f','Julian','Müller','julian.mueller@example.com','https://unit-3-api-6b6268be0363.herokuapp.com/avatars/b835f6db-9340-4458-ae15-ea382ccc5c7f.jpg','555-555-0109','data scientist','Hiring'),
('9097bd35-29cd-4c9d-843d-65402d971306','Isabelle','Rossi','isabelle.rossi@example.com','https://unit-3-api-6b6268be0363.herokuapp.com/avatars/9097bd35-29cd-4c9d-843d-65402d971306.jpg','555-555-0110','software architect','Professional development'),
('41bf5cca-1f91-4b89-9374-58c1ef9b0e12','Carlos','Silva','carlos.silva@example.com','https://unit-3-api-6b6268be0363.herokuapp.com/avatars/41bf5cca-1f91-4b89-9374-58c1ef9b0e12.jpg','555-555-0111','mobile developer','Just for fun'),
('18b8b13a-8c77-4864-87f9-cd02ba78ea54','Emily','Johnson','emily.johnson@example.com','https://unit-3-api-6b6268be0363.herokuapp.com/avatars/18b8b13a-8c77-4864-87f9-cd02ba78ea54.jpg','555-555-0112','qa engineer','Networking'),
('4dc727a2-a940-43dc-9c0c-d8bd8444731e','Ravi','Patel','ravi.patel@example.com','https://unit-3-api-6b6268be0363.herokuapp.com/avatars/4dc727a2-a940-43dc-9c0c-d8bd8444731e.jpg','555-555-0113','tech lead','Hiring'),
('c60d6e84-ad08-4c88-b0f1-493492d9f1cf','Hana','Yamamoto','hana.yamamoto@example.com','https://unit-3-api-6b6268be0363.herokuapp.com/avatars/c60d6e84-ad08-4c88-b0f1-493492d9f1cf.jpg','555-555-0114','machine learning engineer','Professional development'),
('d183df23-3cf4-408b-bdf9-b42e866dedd8','Jasper','van Dijk','jasper.vandijk@example.com','https://unit-3-api-6b6268be0363.herokuapp.com/avatars/d183df23-3cf4-408b-bdf9-b42e866dedd8.jpg','555-555-0115','security engineer','Job searching'),
('82c2b9c6-7785-4294-925e-ccdc6ff71030','Leila','Farahani','leila.farahani@example.com','https://unit-3-api-6b6268be0363.herokuapp.com/avatars/82c2b9c6-7785-4294-925e-ccdc6ff71030','555-555-0116','cloud engineer','Networking'),
('40e841bc-1860-4128-8c57-5ffaa590812a','Oscar','Andersson','oscar.andersson@example.com','https://unit-3-api-6b6268be0363.herokuapp.com/avatars/40e841bc-1860-4128-8c57-5ffaa590812a.jpg','555-555-0117','blockchain developer','Just for fun'),
('9554ff3f-840f-4027-b656-508485f0d102','Zara','Ahmed','zara.ahmed@example.com','https://unit-3-api-6b6268be0363.herokuapp.com/avatars/9554ff3f-840f-4027-b656-508485f0d102.jpg','555-555-0118','data analyst','Professional development'),
('646daee5-3598-4ecc-b644-932b6009d38f','Tobias','Schneider','tobias.schneider@example.com','https://unit-3-api-6b6268be0363.herokuapp.com/avatars/646daee5-3598-4ecc-b644-932b6009d38f.jpg','555-555-0119','system administrator','Job searching'),
('a39ad947-66ee-4295-8bad-2b79a3e408d8','Freya','O''Connell','freya.oconnell@example.com','https://unit-3-api-6b6268be0363.herokuapp.com/avatars/a39ad947-66ee-4295-8bad-2b79a3e408d8.jpg','555-555-0120','scrum master','Networking');

-- Insert attendee_events
INSERT INTO `attendee_events` (`attendee_id`, `event_id`) VALUES
('8f819e96-b42d-41ec-a5ea-d42b6f245e0d','e41c542f-4e9a-4ee8-badb-06090d10df36'),
('8f819e96-b42d-41ec-a5ea-d42b6f245e0d','e1ea5ebe-8a22-4bf6-b91d-4d7353c1d02c'),
('8f819e96-b42d-41ec-a5ea-d42b6f245e0d','24811b5d-2f7b-4dc7-aa5c-44dd9f17fa17'),
('4cb928d2-9853-45c5-bd93-5c37741e567a','95335c2a-c9d4-40da-ad59-6488f993a0d8'),
('4cb928d2-9853-45c5-bd93-5c37741e567a','d3849566-f81f-4739-a921-97141964dd6e'),
('4cb928d2-9853-45c5-bd93-5c37741e567a','c5b88ab5-c8c4-4e7f-8344-458ec32bbf29'),
('98d6a02c-c101-4473-9a07-337b5d67c31a','e41c542f-4e9a-4ee8-badb-06090d10df36'),
('98d6a02c-c101-4473-9a07-337b5d67c31a','d3849566-f81f-4739-a921-97141964dd6e'),
('c45c9284-6299-475a-bd51-1a0f16782b29','e1ea5ebe-8a22-4bf6-b91d-4d7353c1d02c'),
('c45c9284-6299-475a-bd51-1a0f16782b29','21d5baa2-ef1e-4bc1-a879-d5f3cd2d6b96'),
('6ff8dfc3-d1ca-4602-88a1-ebf355e35ef0','95335c2a-c9d4-40da-ad59-6488f993a0d8'),
('6ff8dfc3-d1ca-4602-88a1-ebf355e35ef0','24811b5d-2f7b-4dc7-aa5c-44dd9f17fa17'),
('7d7ae252-a724-4cbd-98d9-4b18f93d5a0a','e41c542f-4e9a-4ee8-badb-06090d10df36'),
('7d7ae252-a724-4cbd-98d9-4b18f93d5a0a','c5b88ab5-c8c4-4e7f-8344-458ec32bbf29'),
('7d7ae252-a724-4cbd-98d9-4b18f93d5a0a','21d5baa2-ef1e-4bc1-a879-d5f3cd2d6b96'),
('c968b861-f8ab-4d33-bf72-530db6a4d476','24811b5d-2f7b-4dc7-aa5c-44dd9f17fa17'),
('c968b861-f8ab-4d33-bf72-530db6a4d476','d3849566-f81f-4739-a921-97141964dd6e'),
('1ad2a80a-283e-480a-bf6c-bee28427a052','e41c542f-4e9a-4ee8-badb-06090d10df36'),
('1ad2a80a-283e-480a-bf6c-bee28427a052','95335c2a-c9d4-40da-ad59-6488f993a0d8'),
('b835f6db-9340-4458-ae15-ea382ccc5c7f','e1ea5ebe-8a22-4bf6-b91d-4d7353c1d02c'),
('b835f6db-9340-4458-ae15-ea382ccc5c7f','24811b5d-2f7b-4dc7-aa5c-44dd9f17fa17'),
('9097bd35-29cd-4c9d-843d-65402d971306','d3849566-f81f-4739-a921-97141964dd6e'),
('41bf5cca-1f91-4b89-9374-58c1ef9b0e12','80de41c8-f689-4c20-8276-1dab81e8f909'),
('18b8b13a-8c77-4864-87f9-cd02ba78ea54','ffb22e67-bc7f-4f41-8e44-2989cdf57ba5'),
('4dc727a2-a940-43dc-9c0c-d8bd8444731e','5d4321b4-f864-4b29-963f-53cf292d06af'),
('c60d6e84-ad08-4c88-b0f1-493492d9f1cf','68edd79d-27d5-4477-bba9-6b5cb93fcfe9'),
('d183df23-3cf4-408b-bdf9-b42e866dedd8','d6564e74-7f3d-4777-aeb7-81b18d4a2fee'),
('82c2b9c6-7785-4294-925e-ccdc6ff71030','24811b5d-2f7b-4dc7-aa5c-44dd9f17fa17'),
('40e841bc-1860-4128-8c57-5ffaa590812a','3432d42a-7e86-4a3d-8376-653e412f29d0'),
('a39ad947-66ee-4295-8bad-2b79a3e408d8','d3849566-f81f-4739-a921-97141964dd6e'),
('9554ff3f-840f-4027-b656-508485f0d102','e41c542f-4e9a-4ee8-badb-06090d10df36'),
('9554ff3f-840f-4027-b656-508485f0d102','95335c2a-c9d4-40da-ad59-6488f993a0d8'),
('646daee5-3598-4ecc-b644-932b6009d38f','24811b5d-2f7b-4dc7-aa5c-44dd9f17fa17'),
('646daee5-3598-4ecc-b644-932b6009d38f','d3849566-f81f-4739-a921-97141964dd6e');