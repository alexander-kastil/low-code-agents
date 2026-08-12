using System.ComponentModel.DataAnnotations.Schema;
using System.Text.Json;
using System.Text.Json.Serialization;

namespace HRMCPServer;

public class Employee
{
    [JsonIgnore]
    public int Id { get; set; }

    [JsonPropertyName("firstname")]
    public string FirstName { get; set; } = string.Empty;

    [JsonPropertyName("lastname")]
    public string LastName { get; set; } = string.Empty;

    [JsonPropertyName("email")]
    public string Email { get; set; } = string.Empty;

    [JsonIgnore]
    public string SpokenLanguagesData { get; set; } = "[]";

    [NotMapped]
    [JsonPropertyName("spoken_languages")]
    public List<string> SpokenLanguages
    {
        get => DeserializeList(SpokenLanguagesData);
        set => SpokenLanguagesData = SerializeList(value);
    }

    [JsonIgnore]
    public string SkillsData { get; set; } = "[]";

    [NotMapped]
    [JsonPropertyName("skills")]
    public List<string> Skills
    {
        get => DeserializeList(SkillsData);
        set => SkillsData = SerializeList(value);
    }

    [JsonPropertyName("current_role")]
    public string CurrentRole { get; set; } = string.Empty;

    public string FullName => $"{FirstName} {LastName}";

    private static List<string> DeserializeList(string? json)
    {
        if (string.IsNullOrWhiteSpace(json))
        {
            return new List<string>();
        }

        try
        {
            var result = JsonSerializer.Deserialize<List<string>>(json);
            return result ?? new List<string>();
        }
        catch
        {
            return new List<string>();
        }
    }

    private static string SerializeList(List<string>? values)
    {
        return JsonSerializer.Serialize(values ?? new List<string>());
    }
}

public class EmployeeCollection
{

    public List<Employee> Employees { get; set; } = new();
}

public class ShiftAssignment
{
    [JsonIgnore]
    public int Id { get; set; }

    [JsonIgnore]
    public int EmployeeId { get; set; }

    [JsonPropertyName("employee_name")]
    public string EmployeeName { get; set; } = string.Empty;

    [JsonPropertyName("date")]
    public DateOnly Date { get; set; }

    [JsonPropertyName("position")]
    public string Position { get; set; } = string.Empty;

    [JsonPropertyName("shift_start_hour")]
    public int ShiftStartHour { get; set; } = 8;

    [JsonPropertyName("shift_end_hour")]
    public int ShiftEndHour => ShiftStartHour + 8;
}

public class ShiftAssignmentCollection
{
    public List<ShiftAssignment> Assignments { get; set; } = new();
}
