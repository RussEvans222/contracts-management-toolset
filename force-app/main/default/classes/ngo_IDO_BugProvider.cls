global class ngo_IDO_BugProvider extends DataSource.Provider {
    override global List<DataSource.AuthenticationCapability> getAuthenticationCapabilities() {
        return new List<DataSource.AuthenticationCapability>{DataSource.AuthenticationCapability.ANONYMOUS};
    }

    override global List<DataSource.Capability> getCapabilities() {
        return new List<DataSource.Capability>{DataSource.Capability.ROW_QUERY, DataSource.Capability.SEARCH};
    }

    override global DataSource.Connection getConnection(DataSource.ConnectionParams connectionsParams) {

        return new NGO_IDO_ReleaseNotes(connectionsParams);
    }
}