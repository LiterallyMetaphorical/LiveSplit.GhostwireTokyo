
state("GWT")
{
    int loading : 0x552CEB8; 
}

init 
{
    // Basically finding and naming the exe we want to target as I understand it
    switch(modules.First().ModuleMemorySize)
    {
	case 688128 :
        version = "wrongEXE";
        break;
    }
    
    // Now using the exe we found earlier, we can tell livesplit to leave it alone and find the correct exe we want to read from
    if (version == "wrongEXE") {
        var allComponents = timer.Layout.Components;
        // Grab the autosplitter from splits
        if (timer.Run.AutoSplitter != null && timer.Run.AutoSplitter.Component != null) {
            allComponents = allComponents.Append(timer.Run.AutoSplitter.Component);
        }
        foreach (var component in allComponents) {
            var type = component.GetType();
            if (type.Name == "ASLComponent") {
                // Could also check script path, but renaming the script breaks that, and
                //  running multiple autosplitters at once is already just asking for problems
                var script = type.GetProperty("Script").GetValue(component);
                script.GetType().GetField(
                    "_game",
                    BindingFlags.NonPublic | BindingFlags.Instance
                ).SetValue(script, null);
            }
        }
        return;
    }
}

startup
{
    refreshRate = 30;

    // Checks if the current comparison is set to Real Time
    // Asks user to change to Game Time if LiveSplit is currently set to Real Time.
    if (timer.CurrentTimingMethod == TimingMethod.RealTime)
    {
        var timingMessage = MessageBox.Show (
            "This game uses Time without Loads (Game Time) as the main timing method.\n"+
            "LiveSplit is currently set to show Real Time (RTA).\n"+
            "Would you like to set the timing method to Game Time?",
            "LiveSplit | Ghostwire: Tokyo",
            MessageBoxButtons.YesNo, MessageBoxIcon.Question
        );

        if (timingMessage == DialogResult.Yes)
            timer.CurrentTimingMethod = TimingMethod.GameTime;
    }
}

onStart
{
    // This is part of a "cycle fix", makes sure the timer always starts at 0.00
    timer.IsGameTimePaused = true;
}

isLoading
{
    return current.loading != 1;
}

update
  {
    print(current.loading.ToString());
  }


exit
{
    timer.IsGameTimePaused = true;
}