Just shipped 𝗧𝗮𝘀𝗸𝗠𝗮𝘀𝘁𝗲𝗿 - A Full-Stack Real-Time Task Management Platform 🚀
I spent the last few weeks building a production-grade collaboration tool from scratch. I wanted to move beyond simple CRUD apps and tackle real backend complexity. Think Trello meets real-time collaboration.

𝗧𝗵𝗲 𝗧𝗲𝗰𝗵 𝗦𝘁𝗮𝗰𝗸:

• Backend (Django, DRF & PostgreSQL): Engineered a 𝗥𝗘𝗦𝗧 𝗔𝗣𝗜 with 35+ endpoints, JWT auth, advanced filtering, and automated 𝗗𝗷𝗮𝗻𝗴𝗼 𝗦𝗶𝗴𝗻𝗮𝗹𝘀 for the activity feed. Fully documented the entire API using 𝗦𝘄𝗮𝗴𝗴𝗲𝗿 𝗨𝗜. Designed a robust 𝗣𝗼𝘀𝘁𝗴𝗿𝗲𝗦𝗤𝗟 database with custom models

• Real-Time (𝗪𝗲𝗯𝗦𝗼𝗰𝗸𝗲𝘁𝘀): Integrated Django Channels, Daphne, and 𝗥𝗲𝗱𝗶𝘀 to securely push live notifications to users across the app.

• Infrastructure (𝗔𝘇𝘂𝗿𝗲 & 𝗗𝗼𝗰𝗸𝗲𝗿): Containerized the entire stack (4 containers) using 𝗗𝗼𝗰𝗸𝗲𝗿 𝗖𝗼𝗺𝗽𝗼𝘀𝗲 and deployed it behind an 𝗡𝗴𝗶𝗻𝘅 reverse proxy on 𝗠𝗶𝗰𝗿𝗼𝘀𝗼𝗳𝘁 𝗔𝘇𝘂𝗿𝗲.

• Frontend (Vanilla JS): Built a responsive Kanban board entirely from scratch with strict role-based access controls.

📚 The Journey: This also became a massive documentation project. I wrote over 100+ 𝗺𝗮𝗿𝗸𝗱𝗼𝘄𝗻 𝗳𝗶𝗹𝗲𝘀 tracking every architectural decision and bug I hit. Wrestling with Docker indenting and custom WebSocket middleware had me debugging for hours, proving that production is a whole different beast than localhost.

But 36 commits later, it works. It's fast, and multiple people can use it simultaneously without it breaking.

A huge thank you to @Rishabh Gupta for guiding me through the Django and REST API architecture. Really appreciate the mentorship!

GitHub: https://github.com/keshav138/taskmaster-main
Try It: 🌐 https://taskmaster-keshav.duckdns.org/
#BackendDevelopment #Django #Docker #PostgreSQL #WebSockets #RealTime #SoftwareEngineering #Azure #WebDevelopment #RestAPI