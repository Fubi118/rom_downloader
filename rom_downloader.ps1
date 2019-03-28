param (
$console = "nintendo-64",
$folder = "$HOME\Desktop\roms\$console\"
)
$found_games = 
$found_games_link_1 = @()
$found_games_link_2 = @()
$counter = 0
$loop = $true

$save_file = ""

Write-Host `n "gathering Roms and Preparing Download... This can take some minutes" `n
for($i=0; $loop -eq $true; $i++) 
{
    $path = "https://romsmode.com/roms/" + $console + "/" + $i + "?genre=&name=&region="
    try{
        $found_games += ((Invoke-WebRequest -Uri $path).links | Where-Object {$_.href -match "\d{6,6}"}).innerHTML
        $found_games_link_1 += @((Invoke-WebRequest -Uri $path).links | Where-Object {$_.href -match "\d{6,6}"}).href
    }
    catch{
        $loop = $false
    }
}
$found_games_link_2 += $found_games_link_1.Replace("https://romsmode.com/", "https://romsmode.com/download/") | select -Unique
$found_games_count = ($found_games_link_2).count
Write-Host -Separator "`n" $found_games | select -Unique 
Write-Host `n "Prepared Roms for Download: " $found_games_count `n
Write-Host "need help? get-Help rom_downloader.ps1"

If(!(Test-Path $folder))
{
    New-Item -ItemType Directory -Force -Path $folder
}

foreach($a in $found_games_link_2)
{



    $game_link_name = $a.Split("/")
    $game_download = ((Invoke-WebRequest -Uri $a).links | Where-Object {$_.class -eq "wait__link"}).href

    $save_file = $folder + $game_link_name[6] + ".zip"

    Write-Progress -Activity "Downloading: $($game_link_name[6])" -Status "$counter/$found_games_count complete" -PercentComplete (((100 / $found_games_count) * $counter))

    Invoke-WebRequest -Uri $game_download -OutFile $save_file
    $counter++

}



<#
.SYNOPSIS
    Script to Download roms from romsmode.com.

.DESCRIPTION
    This Script downloads Roms by your choices.

    Downloadpath = Desktop\rom_games\

.PARAMETER console

    gameboy,acorn-8-bit
    acorn-archimedes
    acorn-electron
    amiga-500
    amstrad-cpc
    amstrad-gx4000
    apple-i
    apple-ii
    apple-ii-gs
    atari-2600
    atari-5200
    atari-7800
    atari-800
    atari-jaguar
    atari-lynx
    atari-st
    bally-pro-arcade-astrocade
    bbc-micro
    camputers-lynx
    capcom-play-system-1
    capcom-play-system-2
    casio-loopy
    casio-pv1000
    colecovision
    colecovision-adam
    commodore-64
    commodore-max-machine
    commodore-pet
    commodore-plus4-c16
    commodore-vic20
    dragon-data-dragon
    elektronika-bk
    emerson-arcadia-2001
    entex-adventure-vision
    epoch-super-cassette-vision
    fairchild-channel-f
    funtech-super-acan
    galaksija
    game-gear
    gameboy
    gameboy-advance
    gameboy-color
    gamecube
    gamepark-gp32
    gce-vectrex
    hartung-game-master
    intellivision
    interact-family-computer
    kaypro-ii
    luxor-abc-800
    magnavox-odyssey-2
    mame
    mattel-aquarius
    memotech-mtx512
    miles-gordon-sam-coupe
    msx-2
    msx-computer
    neo-geo
    neo-geo-pocket
    neo-geo-pocket-color
    nintendo
    nintendo-3ds
    nintendo-64
    nintendo-ds
    nintendo-famicom-disk-system
    nintendo-pokemon-mini
    nintendo-virtual-boy
    nintendo-wii
    nokia-n-gage
    pel-varazdin-orao
    philips-videopac
    playstation
    playstation-2
    playstation-portable
    rca-studio-ii
    robotron-z1013
    sega-32x
    dreamcast
    sega-genesis
    sega-master-system
    sega-pico
    sega-sg1000
    sega-super-control-station
    sega-visual-memory-system
    sharp-mz-700
    sharp-x68000
    sinclair-zx81
    sufami-turbo
    super-grafx
    super-nintendo
    tandy-color-computer
    tangerine-oric
    thomson-mo5
    tiger-game-com
    turbografx-16
    vtech-creativision
    vtech-v-smile
    wang-vs
    watara-supervision
    wonderswan
    microsoft-xbox
    z-machine-infocom
    zx-spectrum

.PARAMETER folder
Path of the destination folder (e.g. D

.EXAMPLE
    rom_downloader.ps1 -console gameboy

.EXAMPLE
    rom_downloader.ps1 -console commodore-64

#>
