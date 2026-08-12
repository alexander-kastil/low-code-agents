namespace HRMCPServer.Services;

public interface IEmployeeService
{

    Task<List<Employee>> GetAllEmployeesAsync();

    Task<bool> AddEmployeeAsync(Employee employee);

    Task<bool> UpdateEmployeeAsync(string email, Action<Employee> updateAction);

    Task<bool> RemoveEmployeeAsync(string email);

    Task<List<Employee>> SearchEmployeesAsync(string searchTerm);

    Task<ShiftAssignment?> AssignShiftAsync(string employeeName, DateOnly date, string position, int shiftStartHour = 8);
}
