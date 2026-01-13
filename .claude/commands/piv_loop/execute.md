---
description: Execute an implementation plan
argument-hint: "<path-to-plan.md>"
---

# Execute: Implement from Plan

## Plan to Execute

Read plan file: `$ARGUMENTS`

**Example:** `.claude/agents/plans/example-feature-address-validation.md`

## Execution Instructions

### 1. Read and Understand

**CRITICAL: Read the ENTIRE plan carefully first!**

- Read the plan file from start to finish
- Understand all tasks and their dependencies
- Note the validation commands to run
- Review the testing strategy
- **Read all "MUST READ" files listed in the plan**

**DO NOT skip this step!** The success of one-pass implementation depends on thorough understanding.

### 2. Read Prime Context

Before starting implementation, read the prime context:

```bash
Read .claude/agents/context/prime-context.md
```

This provides the overall codebase context that the plan builds upon.

### 2.5. Verify Feature Branch

**CRITICAL: You MUST be on a feature branch!**

Check current branch:
```bash
git branch --show-current
```

**If on `main` branch:**
1. **STOP** - Do not implement on main!
2. Ask user: "Should I create a feature branch for this implementation?"
3. If approved, create branch:
   ```bash
   git checkout -b feature/<feature-name>
   ```
4. Then proceed with implementation

**If on feature branch:**
- ✅ Continue with implementation
- Verify branch name is descriptive (e.g., `feature/user-auth`, `fix/login-bug`)

**Rationale:**
- Protects main branch from uncommitted changes
- Allows for review before merging
- Facilitates rollback if needed
- Standard practice for team collaboration

### 3. Read All Mandatory Files

The plan lists files under "CONTEXT REFERENCES > Relevant Codebase Files (MUST READ!)"

**Read each file carefully:**
- Pay attention to patterns used
- Note naming conventions
- Understand error handling
- Observe logging patterns

**Example:**
```bash
# Read controller pattern
Read backend/src/main/java/com/example/controller/ExampleController.java

# Read service pattern
Read backend/src/main/java/com/example/service/ExampleService.java

# Read entity pattern
Read backend/src/main/java/com/example/entity/Example.java
```

### 4. Execute Tasks in Order

For EACH task in "STEP-BY-STEP TASKS":

#### a. Navigate to the task

- Identify the file and action required
- Read existing related files if modifying
- Check if file exists (for UPDATE tasks)

#### b. Implement the task

- **Follow the detailed specifications exactly**
- Maintain consistency with existing code patterns
- Include proper type annotations (Java) or types (TypeScript)
- Add structured logging where appropriate
- Follow naming conventions from the plan

#### c. Verify as you go

- After each file change, check syntax
- Ensure imports are correct
- Verify types are properly defined

#### d. Run validation command

**CRITICAL:** Run the validation command specified in the task:

```bash
# Example validation commands from tasks
cd backend && mvn clean compile
mvn test -Dtest=ExampleServiceTest
```

**If validation fails:**
- Fix the issue
- Re-run the validation command
- Continue only when it passes

**DO NOT skip validation!** Each task has a validation command for a reason.

### 5. Implement Testing Strategy

After completing implementation tasks:

- **Create all test files** specified in the plan
- **Implement all test cases** mentioned
- **Follow the testing approach** outlined in the plan
- **Ensure tests cover edge cases**

**Run tests after creating each test file:**

```bash
# Backend unit tests
mvn test -Dtest=NewServiceTest

# Backend integration tests
mvn test -Dtest=NewControllerIT

# Frontend tests
npm test -- NewComponent.test.tsx
```

### 6. Run All Validation Commands

Execute **ALL validation commands** from the plan in order:

```bash
# Level 1: Backend Compilation
cd backend && mvn clean compile

# Level 2: Backend Unit Tests
cd backend && mvn test

# Level 3: Backend Integration Tests
cd backend && mvn verify -DskipUnitTests=true

# Level 4: Test Coverage
cd backend && mvn jacoco:report

# Level 5: Frontend Build
cd frontend && npm run build

# Level 6: Manual Validation
# (Feature-specific manual testing steps)
```

**If any command fails:**

1. Identify the failure
2. Fix the issue
3. Re-run the failed command
4. Continue only when it passes

**DO NOT proceed to next validation level until current level passes!**

### 7. Final Verification

Before completing implementation, verify:

**Code Quality:**
- ✅ All tasks from plan completed
- ✅ Code follows project conventions
- ✅ Proper error handling implemented
- ✅ Structured logging added
- ✅ DTOs used (not entities in controllers)
- ✅ Spring Data JDBC patterns followed (not JPA)

**Testing:**
- ✅ All tests created and passing
- ✅ Unit tests cover new functionality
- ✅ Integration tests verify workflows
- ✅ Edge cases tested
- ✅ Coverage >= 80%

**Validation:**
- ✅ All validation commands pass
- ✅ No compilation errors
- ✅ No test failures
- ✅ No linting errors
- ✅ Frontend builds successfully

**Acceptance Criteria:**
- ✅ All acceptance criteria met
- ✅ Feature works as specified
- ✅ No regressions in existing functionality
- ✅ Documentation updated (if required)

## Output Report

Provide completion summary:

### Completed Tasks

List all tasks completed:

- ✅ Task 1: CREATE NewController.java
- ✅ Task 2: CREATE NewService.java
- ✅ Task 3: CREATE NewRepository.java
- ✅ Task 4: CREATE V{next}__description.sql migration
- ✅ Task 5: CREATE NewServiceTest.java
- ✅ Task 6: CREATE NewComponent.tsx

### Files Created

List all new files with paths:

**Backend:**
- `backend/src/main/java/com/example/controller/NewController.java`
- `backend/src/main/java/com/example/service/NewService.java`
- `backend/src/main/java/com/example/repository/NewRepository.java`
- `backend/src/main/java/com/example/dto/NewDTO.java`
- `backend/src/main/resources/db/migration/V{next}__description.sql`
- `backend/src/test/java/com/example/service/NewServiceTest.java`
- `backend/src/test/java/com/example/controller/NewControllerIT.java`

**Frontend:**
- `frontend/src/components/NewComponent.tsx`

### Files Modified

List all modified files with paths:

**Backend:**
- `backend/src/main/resources/application.properties` (added new config)

**Frontend:**
- `frontend/src/api/exampleApi.ts` (added new API endpoint)

### Tests Added

**Test Files Created:**
- `backend/src/test/java/com/example/service/NewServiceTest.java` - 12 test cases
- `backend/src/test/java/com/example/controller/NewControllerIT.java` - 5 integration tests

**Test Cases Implemented:**
- Unit tests: 12 tests covering all service methods
- Integration tests: 5 tests verifying end-to-end workflows
- Edge cases: 4 tests covering error scenarios

**Test Results:**

```bash
# Paste test output here
[INFO] Tests run: 12, Failures: 0, Errors: 0, Skipped: 0
```

### Validation Results

**Level 1: Backend Compilation**
```bash
cd backend && mvn clean compile
# Output: BUILD SUCCESS
```

**Level 2: Backend Unit Tests**
```bash
cd backend && mvn test
# Output: Tests run: 42, Failures: 0, Errors: 0, Skipped: 0
```

**Level 3: Backend Integration Tests**
```bash
cd backend && mvn verify -DskipUnitTests=true
# Output: Tests run: 8, Failures: 0, Errors: 0
```

**Level 4: Test Coverage**
```bash
cd backend && mvn jacoco:report
# Output: Coverage: 85% (meets 80% requirement)
```

**Level 5: Frontend Build**
```bash
cd frontend && npm run build
# Output: Build completed successfully
```

**Level 6: Manual Validation**
- ✅ Tested API endpoint: `curl -X GET http://localhost:8080/api/new`
- ✅ Verified UI: Navigation to `/new-page` works correctly
- ✅ Verified database: Tables created in PostgreSQL

### Overall Status

**Status:** ✅ PASS

**Summary:**
- All 6 tasks completed successfully
- 17 tests added, all passing
- Test coverage: 85%
- All validation commands passing
- Manual testing confirms feature works
- Ready for code review

### Ready for Code Review

Confirm:
- ✅ All changes are complete
- ✅ All validations pass
- ✅ Ready for `/piv:code-review`

## Notes

**If you encounter issues not addressed in the plan:**

1. **Document them** in the execution report
2. **Explain why** you deviated from the plan
3. **Describe the solution** you implemented

**If tests fail:**

1. Fix implementation until tests pass
2. DO NOT modify tests to make them pass
3. Ensure tests are testing correct behavior

**If validation commands fail:**

1. Identify root cause
2. Fix the issue
3. Re-run the validation command
4. Continue until all validations pass

**Important:**
- Don't skip validation steps
- Don't skip reading "MUST READ" files
- Don't deviate from plan without documenting why
- Don't proceed until each validation passes

## Next Steps (AUTOMATIC)

**IMPORTANT:** The following steps now run AUTOMATICALLY to ensure code quality.

### Automatic Validation Flow

After implementation completes, the system will **automatically**:

1. **Run Code Review** - Technical quality analysis
   - Checks for bugs, security issues, performance problems
   - Verifies Example standards compliance
   - If issues found → Auto-fix and re-review

2. **Run System Review** (Parallel) - Process improvement analysis
   - Analyzes PIV process quality
   - Documents lessons learned
   - Identifies future improvements (doesn't block)

3. **Run Final Validation** - Complete validation suite
   - Compilation verification
   - Unit tests
   - Integration tests
   - Coverage check (≥80%)
   - Security scan
   - Performance check

4. **Ready State** - Stop when all pass
   - Report: "✅ FEATURE COMPLETE - ALL VALIDATIONS PASSED"
   - Summary: Files created, tests added, coverage achieved
   - Next step: **Create pull request for review**

### What You Need To Do

**During automatic flow:**
- Watch progress (you'll see each step running)
- If manual fixes needed → System will ask you
- If automatic fixes possible → System will apply them
- Loop until all validations pass

**When feature is complete:**
- You'll see: "✅ READY TO COMMIT"
- Review the summary
- **CRITICAL: Follow the commit workflow below**

### Commit Workflow for Feature Branches

**After implementation completes, you are on a feature branch.**

**Step 1: Commit your changes**
```bash
/commit
```
This will create a commit with all your changes on the feature branch.

**Step 2: Push to remote**
```bash
git push -u origin <your-feature-branch>
```

**Step 3: Create Pull Request**
```bash
gh pr create --title "Feature: <brief description>" --body "Summary of changes"
```

**Step 4: Merge to main (ONLY after review and approval)**
- ✅ Pull request must be reviewed
- ✅ All checks must pass
- ✅ Get explicit approval from maintainer
- Then merge to main

**IMPORTANT:**
- ❌ **NEVER** commit directly to main without approval
- ❌ **NEVER** push directly to main branch
- ✅ **ALWAYS** use feature branches for implementations
- ✅ **ALWAYS** create PR for review before merging to main

### Manual Override (Optional)

If you want to skip automatic validation and run manually:

```bash
# Skip automatic flow, run individual commands
/validation:code-review
/validation:code-review-fix <report-path>
/validation:validate
```

**But why?** Automatic flow ensures consistent quality and catches issues early.

---

**Remember:** The goal is one-pass implementation with automatic quality gates. If you followed the plan and all validations pass, you succeeded! 🎉
