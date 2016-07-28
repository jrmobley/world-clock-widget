
command: "world-clock.widget/command.sh"

refreshFrequency: '1m'

style: """
clock-background = rgba(0,0,0,.5)
clock-text = white
zone-background = rgba(0,0,0,1)
zone-border-color = rgba(255,255,255,.8)
zone-border-width = 2px
zone-text = white
zone-bar-height = 1.2em

width 100%

.world.clock
    width 100%
    background-color clock-background
    border-color clock-text
    border-style solid
    border-width 0 0 1px 0
    font-family 'Share Tech Mono'
    font-size smaller
    margin-bottom 1.5em

.hours.bar
    padding-top 1.4em
    display flex
    flex-flow row no-wrap
    width 200%
    position relative

.hour
    height 1.5em
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

.today
    display inline-block
    color zone-text
    position absolute
    top 100%
    left 25%

.tomorrow
    display inline-block
    color zone-text
    position absolute
    top 100%
    left 75%

.zone
    display inline-block
    color zone-text
    background-color zone-background
    background-clip padding-box
    border-color zone-border-color
    border-width zone-border-width
    border-style solid
    border-radius 0 8px 8px 8px
    padding-left .5em
    padding-right .5em
    padding-top .1em
    padding-bottom .1em
    position absolute
    top 0
    transform-origin top left
    transform: rotate(30deg)
"""

render: (output) ->
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

    hourElements.push """
        <div class="today">Today</div>
        <div class="tomorrow">Tomorrow</div>
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
                <div class="zone" style="left:#{left};">#{name}</div>
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
    locale = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday']
    time = new Date()
    today = time.getUTCDay()
    tomorrow = (today + 1) % 7
    hour = time.getUTCHours()
    minute = time.getUTCMinutes()
    offset = -(hour + minute / 60)
    hoursLeft = offset / 24 * 100 + '%'
    $(domEl).find('.hours.bar').css('left', hoursLeft)
    $(domEl).find('.today').text(locale[today])
    $(domEl).find('.tomorrow').text(locale[tomorrow])
