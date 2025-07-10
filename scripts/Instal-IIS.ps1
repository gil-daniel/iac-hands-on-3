Configuration InstallIIS
{
	Node "localhost"
	{
		WindowsFeature IIS
		{
			Name = "Web-Server"
			Ensure = "Present"
		}
	}
}

InstallIIS
