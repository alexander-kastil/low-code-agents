using HRMCPServer.Data;
using Microsoft.EntityFrameworkCore;

namespace HRMCPServer.Services;

public class EmployeeService(
    EmployeeDbContext dbContext,
    ILogger<EmployeeService> logger) : IEmployeeService
{
    public async Task<List<Employee>> GetAllEmployeesAsync()
    {
        return await dbContext.Employees
            .AsNoTracking()
            .OrderBy(c => c.LastName)
            .ThenBy(c => c.FirstName)
            .ToListAsync();
    }

    public async Task<bool> AddEmployeeAsync(Employee employee)
    {
        if (employee == null)
            throw new ArgumentNullException(nameof(employee));

        var email = employee.Email.Trim();

        if (await dbContext.Employees.AnyAsync(c => c.Email == email))
        {
            return false;
        }

        employee.Email = email;

        await dbContext.Employees.AddAsync(employee);
        await dbContext.SaveChangesAsync();

        logger.LogInformation("Added new employee: {FullName} ({Email})", employee.FullName, employee.Email);
        return true;
    }

    public async Task<bool> UpdateEmployeeAsync(string email, Action<Employee> updateAction)
    {
        if (string.IsNullOrWhiteSpace(email))
            throw new ArgumentException("Email cannot be null or empty", nameof(email));

        if (updateAction == null)
            throw new ArgumentNullException(nameof(updateAction));

        var normalizedEmail = email.Trim();

        var employee = await dbContext.Employees
            .FirstOrDefaultAsync(c => c.Email == normalizedEmail);

        if (employee == null)
        {
            return false;
        }

        updateAction(employee);
        await dbContext.SaveChangesAsync();

        logger.LogInformation("Updated employee with email: {Email}", normalizedEmail);
        return true;
    }

    public async Task<bool> RemoveEmployeeAsync(string email)
    {
        if (string.IsNullOrWhiteSpace(email))
            throw new ArgumentException("Email cannot be null or empty", nameof(email));

        var normalizedEmail = email.Trim();

        var employee = await dbContext.Employees
            .FirstOrDefaultAsync(c => c.Email == normalizedEmail);

        if (employee == null)
        {
            return false;
        }

        dbContext.Employees.Remove(employee);
        await dbContext.SaveChangesAsync();

        logger.LogInformation("Removed employee with email: {Email}", normalizedEmail);
        return true;
    }

    public async Task<List<Employee>> SearchEmployeesAsync(string searchTerm)
    {
        if (string.IsNullOrWhiteSpace(searchTerm))
        {
            return await GetAllEmployeesAsync();
        }

        var searchTermLower = searchTerm.Trim().ToLowerInvariant();

        var employees = await dbContext.Employees
            .AsNoTracking()
            .ToListAsync();

        var matchingEmployees = employees.Where(c =>
            c.FirstName.ToLowerInvariant().Contains(searchTermLower) ||
            c.LastName.ToLowerInvariant().Contains(searchTermLower) ||
            c.Email.ToLowerInvariant().Contains(searchTermLower) ||
            c.CurrentRole.ToLowerInvariant().Contains(searchTermLower) ||
            c.Skills.Any(skill => skill.ToLowerInvariant().Contains(searchTermLower)) ||
            c.SpokenLanguages.Any(lang => lang.ToLowerInvariant().Contains(searchTermLower))
        ).ToList();

        return matchingEmployees;
    }

    public async Task<ShiftAssignment?> AssignShiftAsync(string employeeName, DateOnly date, string position, int shiftStartHour = 8)
    {
        if (string.IsNullOrWhiteSpace(employeeName))
            throw new ArgumentException("Employee name cannot be empty", nameof(employeeName));

        var nameLower = employeeName.Trim().ToLowerInvariant();

        var employees = await dbContext.Employees.ToListAsync();

        var employee = employees.FirstOrDefault(e =>
            e.FullName.ToLowerInvariant().Contains(nameLower) ||
            e.FirstName.ToLowerInvariant().Contains(nameLower) ||
            e.LastName.ToLowerInvariant().Contains(nameLower));

        if (employee == null)
            return null;

        var shift = new ShiftAssignment
        {
            EmployeeId = employee.Id,
            EmployeeName = employee.FullName,
            Date = date,
            Position = position.Trim(),
            ShiftStartHour = shiftStartHour
        };

        await dbContext.ShiftAssignments.AddAsync(shift);
        await dbContext.SaveChangesAsync();

        logger.LogInformation("Assigned {EmployeeName} to {Position} on {Date} starting at {Hour}:00",
            employee.FullName, position, date, shiftStartHour);

        return shift;
    }
}
