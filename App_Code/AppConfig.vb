' ============================================================
' AppConfig.vb - central app configuration helpers
' Project: Automation of Canteen Trolley Operation
' ============================================================

Imports System.Configuration

Public Module AppConfig

    Public Function IsTestMode() As Boolean
        Dim raw As String = Nothing
        Try
            raw = ConfigurationManager.AppSettings("IsTestMode")
        Catch
            ' ignore
        End Try

        If String.IsNullOrWhiteSpace(raw) Then Return False
        Dim v As Boolean
        If Boolean.TryParse(raw, v) Then Return v

        ' allow common values: 1/0, yes/no
        Dim s As String = raw.Trim().ToLowerInvariant()
        If s = "1" OrElse s = "yes" OrElse s = "y" OrElse s = "true" Then Return True
        Return False
    End Function

End Module

