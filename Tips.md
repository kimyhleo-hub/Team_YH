# Flexible worklow
- Two levels of granularity within Claude Code
    - Session (resume)
    - Checkpoint (rewind)
- In parallel, a bulletproof way to manage your code
    - Git Commits
- My personal workflow uses Git + occasional Checkpointing and Markdown files to record progress Sessions for exceptional situations (eg working over multiple days)

# claude --dangerously-skip-permissions
- bypass permissions on

# Ralph Loops
- /plugin install ralph-loop@claude-plugins-official 
- /goal

# 3 ways to give Claude abilities
- MCP : Connect Claude Code to someone else's tools
- Skills : Add expertise & capabilities
- Plugins : Convenient bundle of MCP, Skilss and more

# The innovation is Tools
- AN LLM used to generate content. Now it makes decisions & takes action
- Claude Code has tools baked into. it. The ToDo list is a simple & effective example.
- More tools = more functionality. Anthropic needed a way to easily add tools.

# MCP
- The usb-c port for AI applications
- an open-source standard for connecting AI applications to external systems
- It's a way to connect applications like Claude Code to someone else's Tools

# MCP Technicalities
- MCP Host : Claude Code
- MCP Client : Inside Claude Code
- MCP Server : The tools written by someone else

- They can run in two different ways ("transport")
    - Local
    - Remote
- This is a common source of confusion This refers to where the tools run. A tool that runs locally will still often make API calls remotely.
- Local is more common than remote. It still has all the benefits of MCP; the  code is retrieved rmotely, run on your box.

# Skills : 3 levels of "Progressive Disclosure"
- Metadata : Name + description : When should this skill be triggered?
- Instructions : Information with workflows, guidance, code snippets
- Resources + Code : Info that can be accessed & scripts that can be run
- Skills are implemented with a "File System Architecture"
- .claude => skills => my-great-skill/ => SKILL.md, ..
                    => scripts/ => scripts_in_~.py, ..
- The script itself stays out of context. 
- This structure can be in your home directory(all projects) or project directory(project only)

- https://www.skills.sh/

# Plugins
- Pros
    - The most simple
    - Best trade-offs of context and capability
    - Commands are explicitly triggled
- Cons
    - Only available in Claude Code
    - Least configuration
    - May give more functionality than needed


