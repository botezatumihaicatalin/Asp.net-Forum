using System.Configuration;
using System.Data.SqlClient;

/// <summary>
/// Creates a singleton for this.
/// </summary>
public class DatabaseHandler
{
    private static readonly DatabaseHandler Instance = new DatabaseHandler();

    public static DatabaseHandler GetInstance()
    {
        return Instance;
    }

    private readonly string _connectionString = ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;

    private DatabaseHandler()
    {
        DatabaseConnection = new SqlConnection(_connectionString);
    }

    public SqlConnection DatabaseConnection { get; set; }

    public SqlTransaction BeginTransaction()
    {
        return DatabaseConnection.BeginTransaction();
    }
}