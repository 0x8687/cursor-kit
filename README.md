# Cursor Kit

A comprehensive boilerplate template for building professional software projects with **Cursor IDE**. This template provides a complete development environment with AI-powered agent orchestration, automated workflows, and intelligent project management.

## What is Cursor?

**Cursor** is an AI-powered code editor that brings advanced AI assistance directly into your development workflow. It enables natural language interaction with your codebase and provides intelligent automation for common development tasks.

- [Cursor](https://cursor.sh/)
- [Docs](https://docs.cursor.com/)

**Cursor Kit** extends Cursor with specialized AI agents, workflows, and configurations that handle specific aspects of software development - from planning and research to testing and documentation. This creates a collaborative AI development environment that works alongside human developers.

## Related Projects & Directories

Cursor Kit is part of the broader ecosystem of AI-powered development tools. This boilerplate provides a foundation for building professional software projects with Cursor IDE.

## Key Benefits

### 🚀 Accelerated Development
- **AI-Powered Planning**: Automated technical planning and architecture design
- **Intelligent Code Generation**: Context-aware code creation and modification
- **Automated Testing**: Comprehensive test generation and execution
- **Smart Documentation**: Synchronized docs that evolve with your code

### 🎯 Enhanced Quality
- **AI-Powered Code Review**: Intelligent code quality analysis and recommendations
- **Automated Quality Assurance**: Continuous testing and validation
- **Best Practices Enforcement**: Built-in adherence to coding standards
- **Security-First Development**: Proactive security analysis and recommendations

### 🏗️ Structured Workflow
- **Workflow Orchestration**: Coordinated development workflows for planning, implementation, and testing
- **Task Management**: Automated project tracking and progress monitoring
- **Documentation Sync**: Always up-to-date technical documentation
- **Clean Git Workflow**: Professional commit messages and branch management

## Documentation

### 📚 Core Documentation
- **[Project Overview & PDR](./docs/project-overview-pdr.md)** - Comprehensive project overview, goals, features, and product development requirements
- **[Codebase Summary](./docs/codebase-summary.md)** - High-level overview of project structure, technologies, and components
- **[Code Standards](./docs/code-standards.md)** - Coding standards, naming conventions, and best practices
- **[System Architecture](./docs/system-architecture.md)** - Detailed architecture documentation, component interactions, and data flow
- **[Tech Stack](./docs/tech-stack.md)** - Technologies and tools used in the project
- **[Project Roadmap](./docs/project-roadmap.md)** - Development roadmap and future plans

### 📖 Additional Resources
- **[CURSOR.md](./CURSOR.md)** - Development instructions and workflows for AI agents
- **[Examples](./examples/)** - Example projects and implementation plans

## Quick Start

### Prerequisites
- [Cursor IDE](https://cursor.sh/) installed and configured
- Git for version control
- Node.js 18+ (or your preferred runtime)
- Operating Systems: macOS 10.15+, Ubuntu 20.04+/Debian 10+, or Windows 10+ (with WSL 1, WSL 2, or Git for Windows)
- Hardware: 4GB+ RAM

### Setup your new project with Cursor Kit

1. **Clone or use this template**:
   ```bash
   git clone https://github.com/0x8687/cursor-kit.git my-project
   cd my-project
   ```

2. **Customize for your project**:
   - Update `CURSOR.md` with your project-specific instructions
   - Modify `.cursor/workflows/` to match your development workflow
   - Update `README.md` with your project details

3. **Start development with Cursor**:
   - Open the project in Cursor IDE
   - Use Cursor's AI features with the configured workflows
   - Follow the development guidelines in `CURSOR.md`

## Project Structure

```
├── .cursor/                # Cursor IDE configuration
│   ├── agents/             # Specialized AI agent definitions
│   ├── commands/           # Custom command implementations
│   ├── hooks/              # Git hooks and automation scripts
│   ├── skills/             # Reusable skills library
│   └── workflows/          # Development workflow definitions
├── docs/                   # Project documentation
│   ├── codebase-summary.md # Auto-generated codebase overview
│   ├── code-standards.md   # Development standards
│   ├── project-overview-pdr.md # Product requirements
│   ├── system-architecture.md # Architecture documentation
│   ├── tech-stack.md       # Technology stack details
│   └── project-roadmap.md  # Development roadmap
├── examples/               # Example projects and plans
│   ├── plans/              # Implementation plan examples
│   └── ScreenshotApp/      # Example macOS application
├── CURSOR.md              # Project-specific Cursor instructions
└── README.md              # This file
```

## Development Capabilities

Cursor Kit provides a structured approach to AI-assisted development with specialized workflows:

### 🎯 Core Development Workflows

#### **Planning & Research**
- Research technical approaches and best practices
- Create comprehensive implementation plans
- Analyze architectural trade-offs
- Document findings and recommendations

#### **Implementation**
- Generate code following project standards
- Build features with AI assistance
- Maintain code quality and consistency
- Follow established patterns and conventions

#### **Testing & Quality**
- Generate comprehensive test suites
- Validate functionality and performance
- Ensure code quality standards
- Perform code reviews

### 🔍 Quality Assurance

#### **Code Review**
- Automated code quality analysis
- Enforce coding standards and conventions
- Identify security vulnerabilities
- Provide improvement recommendations

#### **Debugging**
- Analyze application logs and error reports
- Diagnose performance bottlenecks
- Investigate issues systematically
- Provide root cause analysis

### 📚 Documentation & Management

#### **Documentation Management**
- Maintain synchronized technical documentation
- Update API documentation automatically
- Ensure documentation accuracy
- Manage codebase summaries

#### **Version Control**
- Create clean, conventional commit messages
- Manage branching and merge strategies
- Handle version control workflows
- Ensure professional git history

#### **Project Tracking**
- Track development progress and milestones
- Update project roadmaps and timelines
- Manage task completion
- Maintain project health metrics

## Workflow Patterns

### Sequential Workflow
Use when tasks have dependencies:
1. Planning → Research → Implementation → Testing → Review
2. Each phase builds on the previous one
3. Context is maintained through documentation

### Parallel Execution
Use for independent tasks:
- Multiple research tasks can run simultaneously
- Different features can be developed in parallel
- Testing and documentation can happen concurrently

### Context Management
- Workflows communicate through documentation
- Context is preserved in markdown files
- Essential information is documented for future reference
- Examples and plans are stored in `examples/` directory

## Development Workflow

### 1. Feature Development
1. **Planning**: Review requirements and create implementation plan
2. **Research**: Investigate technologies and approaches (see `examples/plans/` for examples)
3. **Implementation**: Build features following code standards
4. **Testing**: Write and run comprehensive tests
5. **Review**: Code review and quality checks
6. **Documentation**: Update relevant documentation

### 2. Bug Fixing
1. **Analysis**: Investigate the issue using Cursor's AI assistance
2. **Planning**: Create a fix plan
3. **Implementation**: Implement the solution
4. **Validation**: Test the fix thoroughly
5. **Documentation**: Update docs if needed

### 3. Documentation Management
- Keep documentation in `docs/` directory up to date
- Follow documentation standards in `docs/code-standards.md`
- Review and update architecture docs as the project evolves
- Maintain project roadmap and changelog

## Configuration Files

### CURSOR.md
Project-specific instructions for Cursor IDE. Customize this file to define:
- Project architecture guidelines
- Development standards and conventions
- Workflow protocols
- Specific development patterns for your project

### .cursor/workflows/*.md
Workflow definitions that guide development:
- Primary development workflow
- Development rules and standards
- Orchestration protocols
- Documentation management

### examples/plans/
Example implementation plans showing:
- Feature implementation structure
- Bug fix procedures
- Research documentation
- Phase-by-phase development approach

## Cursor Configuration

### Cursor Settings
Cursor IDE can be configured through:
- `.cursor/settings.json` - Project-specific Cursor settings
- Cursor's built-in settings UI
- Workspace-specific configurations

### Workflow Customization
Customize workflows in `.cursor/workflows/`:
- `primary-workflow.md` - Main development cycle
- `development-rules.md` - Coding standards and rules
- `orchestration-protocol.md` - How different workflows coordinate
- `documentation-management.md` - Documentation update procedures

### Skills and Agents
- Skills are reusable knowledge modules in `.cursor/skills/`
- Agents are specialized AI assistants defined in `.cursor/agents/`
- Commands are shortcuts defined in `.cursor/commands/`

## Best Practices

### Development Principles
- **YANGI**: You Aren't Gonna Need It - avoid over-engineering
- **KISS**: Keep It Simple, Stupid - prefer simple solutions
- **DRY**: Don't Repeat Yourself - eliminate code duplication

### Code Quality
- All code changes go through automated review
- Comprehensive testing is mandatory
- Security considerations are built-in
- Performance optimization is continuous

### Documentation
- Documentation evolves with code changes
- API docs are automatically updated
- Architecture decisions are recorded
- Codebase summaries are regularly refreshed

### Git Workflow
- Clean, conventional commit messages
- Professional git history
- No AI attribution in commits
- Focused, atomic commits

## Usage Examples

### Starting a New Feature
1. **Plan**: Use Cursor's AI to research and create an implementation plan
2. **Implement**: Follow the plan and build the feature using Cursor's code generation
3. **Test**: Write tests and validate functionality
4. **Review**: Use Cursor's AI to review code quality
5. **Document**: Update relevant documentation

See `examples/plans/` for detailed implementation plan examples.

### Debugging Issues
1. **Analyze**: Use Cursor's AI to investigate the problem
2. **Plan Fix**: Create a solution plan
3. **Implement**: Apply the fix with AI assistance
4. **Validate**: Test the fix thoroughly

### Project Maintenance
1. **Review Status**: Check project health and progress
2. **Update Docs**: Keep documentation synchronized with code
3. **Plan Next Phase**: Use planning workflows for upcoming work

## Advanced Features

### Example Projects
- **Screenshot App**: Complete macOS screenshot application example
  - Located in `examples/ScreenshotApp/`
  - Shows full implementation with SwiftUI
  - Includes all phases from planning to completion

### Implementation Plans
- Detailed phase-by-phase development plans
- Research documentation examples
- Agent communication reports
- Located in `examples/plans/`

### Workflow Customization
- Extend existing workflows
- Create project-specific patterns
- Integrate with your development tools

## Customization Guide

### 1. Project Setup
- Update `CURSOR.md` with your project specifics
- Modify workflows in `.cursor/workflows/`
- Customize skills and agents in `.cursor/`

### 2. Workflow Customization
- Adapt workflows to your development process
- Add project-specific patterns
- Create custom commands and shortcuts

### 3. Documentation
- Update documentation templates
- Customize code standards
- Maintain project-specific guidelines

## Contributing

1. Fork this repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Follow the development workflow guidelines
4. Ensure all tests pass and documentation is updated
5. Create a Pull Request

**Start building with AI-powered development today!** Cursor Kit provides everything you need to create professional software with Cursor IDE's intelligent assistance.