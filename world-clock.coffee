
command: "world-clock.widget/world-clock.sh"

refreshFrequency: '5m'

style: """
clock-background = rgba(255,255,255,.5)
clock-text = black
city-background = #075698
city-border = city-background
city-text = white
arrow-width = .4em
arrow-height = .6em
arrow-top = 0em - arrow-height
zone-bar-height = arrow-height + 1.6em

width 100%

.world.clock
    width 100%
    background-color clock-background
    border-color black
    border-style solid
    border-width 0 0 1px 0
    font-family 'Share Tech Mono'
    font-size smaller
    margin-bottom 1.5em

.hours.bar
    display flex
    flex-flow row no-wrap
    width 200%
    position relative

.hour
    height 1.5em
    background-color: clock-background
    display flex
    flex-flow row no-wrap
    justify-content center
    align-items center

.hour svg
    width 100%
    height 100%
    stroke clock-text
    overflow visible

.hour svg line
    stroke-width 1px

.hour svg line.full
    stroke-width 2px

.hour svg text
    stroke none
    fill clock-text
    text-anchor middle

.zones.bar
    width 100%
    height zone-bar-height
    position relative
    background-color clock-background

.city
    display inline-block
    color city-text
    background-color city-background
    background-clip border-box
    border-color city-border
    border-width 1px
    border-style solid
    border-radius 0 8px 8px 8px
    padding-left .5em
    padding-right .5em
    position absolute
    top arrow-height

.city:before
    content ""
    position absolute
    top arrow-top
    left -1px
    width 0
    border-top-width arrow-height
    border-right-width 0px
    border-bottom-width 0px
    border-left-width arrow-width
    border-style solid
    border-color transparent city-border
"""

render: (output) ->
    #time = new Date()
    #hour = time.getUTCHours()
    #minute = time.getUTCMinutes()
    #offset = -(hour + minute / 60)
    #hoursLeft = offset / 24 * 100 + '%'

    hourElements = for hour in [12..59]
        h = hour % 24;
        label = if h < 10 then ('0' + h) else ('' + h)
        """
        <div class="hour">
            <svg>
                <text                 x="0%"            y="60%">#{label}</text>
                <line class="full"    x1="0%"  x2="0%"  y1="75%" y2="100%"/>
                <line class="half"    x1="50%" x2="50%" y1="60%" y2="100%"/>
                <line class="quarter" x1="25%" x2="25%" y1="85%" y2="100%"/>
                <line class="quarter" x1="75%" x2="75%" y1="85%" y2="100%"/>
            </svg>
        </div>
        """
    hoursHTML = hourElements.join('')

    zones = output.split('\n')
    zoneElements = for zone in zones
        [name, offset] = zone.split(';')
        if (offset)
            sign = offset.slice(0,1)
            hours = parseInt(offset.slice(1,3), 10)
            minutes = parseInt(offset.slice(3,5), 10)
            offset = (if (sign is '-') then -1 else +1) * (hours * 60 + minutes)
            left = (offset + 720) / 1440 * 100 + '%'
            """
                <div class="city" style="left:#{left};">#{name}</div>
            """
        else
            ""
    zonesHTML = zoneElements.join('')

    """
    <link href='https://fonts.googleapis.com/css?family=Share+Tech+Mono' rel='stylesheet' type='text/css'>
    <div class="world clock">
        <div class="hours bar">
            #{hoursHTML}
        </div>
        <div class="zones bar">
            #{zonesHTML}
        </div>
    </div>
    """

update: (output, domEl) ->
    time = new Date()
    hour = time.getUTCHours()
    minute = time.getUTCMinutes()
    offset = -(hour + minute / 60)
    hoursLeft = offset / 24 * 100 + '%'
    $(domEl).find('.hours.bar').css('left', hoursLeft)
