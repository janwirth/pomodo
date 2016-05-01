iconLink = "http://www.wpclipart.com/food/fruit/tomato/tomato.png"
app = angular.module 'pomodoroApp', []
app.controller 'PomodoroController',
  class PomodoroController
    constructor: ($scope,$interval) ->
      # Ask for notifications
      Notification.requestPermission (status) =>
        notify('Notifications enabled')
        @notificationsEnabled = status is "granted"
      notify = (message) ->
        new Notification(message, {body: "Pomodorski", icon: iconLink})
      playAlertSound = => @audio.play()
			
      # setup
      $scope.booted = true
      $scope.running = false
      $scope.break = false
      $scope.workDuration = 25
      $scope.breakDuration = 5
      $scope.countDown = $scope.workDuration * 60
      @notificationsEnabled = false
      @audio = new Audio('http://www.fenderrhodes.com/audio/mark1b-stage-1979-mellow.mp3')
      
      
      # converter method
      sessionDurationInSeconds = (type) ->
        if type == 'work'
          duration = $scope.workDuration
          $scope.break = false
        if type == 'break'
          duration = $scope.breakDuration
          $scope.break = true
        duration * 60
      
      # countdown method
      count = -> $scope.countDown--
      
      $scope.startSession = (type) =>
        alert('Warning: no notifications') if !@notificationsEnabled
        # stop old timer and set session properties
        $interval.cancel @currentSession if angular.isDefined @currentSession
        $scope.countDown = sessionDurationInSeconds(type)
        @currentSession = $interval count , 1000, $scope.countDown
        
        # when $interval has ended
        @currentSession.then () =>
          newSessionType = if type == 'work' then 'break' else 'work'
          $scope.startSession(newSessionType)
          notify('Time for ' + newSessionType)
          @audio.play()
        $scope.running = true
       
app.filter 'clockTime', ->
  (totalSeconds) ->
    hours = Math.floor(totalSeconds / 3600)
    totalSeconds %= 3600
    minutes = Math.floor(totalSeconds / 60)
    seconds = totalSeconds % 60
    seconds = "0" + seconds if seconds < 10
    minutes + ':' + seconds
