CREATE CONSTRAINT ON (u:User) ASSERT u.id IS UNIQUE;
CREATE CONSTRAINT ON (t:Team) ASSERT t.id IS UNIQUE;
CREATE CONSTRAINT ON (c:TeamChatSession) ASSERT c.id IS UNIQUE;
CREATE CONSTRAINT ON (i:ChatItem) ASSERT i.id IS UNIQUE;

LOAD CSV FROM "file:///chat_create_team_chat.csv" AS row
MERGE (u:User {id: toInt(row[0])})
MERGE (t:Team {id: toInt(row[1])}) 
MERGE (c:TeamChatSession {id: toInt(row[2])})
MERGE (u)-[:CreatesSession{timeStamp: row[3]}]->(c)
MERGE (c)-[:OwnedBy{timeStamp: row[3]}]->(t)

LOAD CSV FROM "file:///chat_item_team_chat.csv" AS row
MERGE (u:User {id: toInt(row[0])})
MERGE (t:TeamChatSession {id: toInt(row[1])})
MERGE (c:ChatItem {id: toInt(row[2])})
MERGE (u)-[:CreatesChat{timeStamp: row[3]}]->(c)
MERGE (c)-[:PartOf{timeStamp: row[3]}]->(t)

LOAD CSV FROM "file:///chat_join_team_chat.csv" AS row
MERGE (u:User {id: toInt(row[0])})
MERGE (c:TeamChatSession {id: toInt(row[1])})
MERGE (u)-[:Joins{timeStamp: row[2]}]->(c)

LOAD CSV FROM "file:///chat_leave_team_chat.csv" AS row
MERGE (u:User {id: toInt(row[0])})
MERGE (c:TeamChatSession {id: toInt(row[1])})
MERGE (u)-[:Leaves{timeStamp: row[2]}]->(c)

LOAD CSV FROM "file:///chat_mention_team_chat.csv" AS row
MERGE (c:ChatItem {id: toInt(row[0])})
MERGE (u:User {id: toInt(row[1])})
MERGE (c)-[:Mentioned{timeStamp: row[2]}]->(u)

LOAD CSV FROM "file:///chat_respond_team_chat.csv" AS row
MERGE (c:ChatItem {id: toInt(row[0])})
MERGE (u:User {id: toInt(row[1])})
MERGE (c)-[:Mentioned{timeStamp: row[2]}]->(u)