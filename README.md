# Azure DevOps Engineer Hiring - BespinGlobal MEA

Hello and thank you for accepting the challenge.

The goal is to assert your basic coding, testing, automation and documentation skills. You're given a simple problem, so that you can focus on showcasing your skills. Please tackle this task as you would do in your work environment.

## Problem definition

The aim of this challenge is to create a simple HTTP service that satisfies certain conditions, then design and deploy the application as a cloud solution, preferably in Azure.

_Note: Please do not create a public repo with your test in! This challenge is only shared with the interviewers at BespinGlobal MEA, and for obvious reasons we'd like it to remain this way._

## Setup

1. Clone this repository.
2. Create a new `dev` branch.
3. Write a simple application that is an 'as easy as possible' HTTP API
4. It should have a `/live` endpoint.

The following responses are possible:

- `Well done` : if the application was able to connect with a database
- `Maintenance`: if some error occurred during the connection with the database

The application should read the configuration file for `PORT` and `DATABASE URL`

## Guidelines

1. Use IaC (prefered Terraform) to create the Azure components and database.
2. Deploy this application to the Azure infrastructure that you prefer (can be on Azure VMSS, AKS, Azure App Service, …).
3. Feel free to choose the Database setup that you feel comfortable to work with.
4. You can think about all possible solutions that support the **scalability**, **resiliency** and **security** of the system.
5. Configuration file(s) that define your resouces and network.
6. Two additional infrastructure configurations (in seperate commits) that add scalability and security
7. Add basic logging/monitoring capabilities (in a seperate commit)
8. Apply CI/CD solution (Prefered - Azure DevOps) to support your approach.
9. Basic Documentation (README.md) and architecture diagram
10. Commit often, we like to see small commits that build up to the end result of your test, instead of one final commit with all the code.
11. Do a pull request from the `dev` branch to the `master` branch.
12. In your pull request, **make sure to write about your approach** and ideally **document** your architected solution.
13. Reply to the email thread you are having with our Talent Acquisition department and inform them you have raised a PR so that we can start reviewing your code.
14. One or more of our engineers will then perform a review of the solution and, in eventual later steps of the interview process, there will be a deep dive on the code and the architected solution. This interaction with your peers should provide a better understanding of what working together might look like.

### Bonus Points

* If you can provision Self Host agents and benefit of private networking.
* If you can document all aspects of your code, in the README and within the code itself.
* If you can make this run all in one playbook.
* Directory/file structure and the naming convention is a plus

### Deliverables

1. The pull request, which should include the code and its documentation, not the deployed solution.

### FEEDBACK

- Did you like the test? Too difficult, too easy, or just right?
- How much time did you spend?
- What can be improved? Ex: Better explanations of the challenge.

#### Thanks for your time, we look forward to hearing from you!

**[BESPIN Global MEA - Professional Services](https://www.bespinglobal.ae/careers)**
