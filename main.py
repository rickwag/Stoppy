# This Python file uses the following encoding: utf-8
import os
from pathlib import Path
import sys

from PySide6.QtGui import QGuiApplication
from PySide6.QtQml import QQmlApplicationEngine
from PySide6.QtCore import QObject, Signal, Slot, QTimer

from datetime import timedelta

class MainWindow(QObject):

    setTime = Signal(str)
    setInitialTimeValues = Signal(list)
    timeOut = Signal()

    def __init__(self):
        QObject.__init__(self)

        self.total_seconds = 120
        self.initial_seconds = self.total_seconds

        self.timer = QTimer()
        self.timer.timeout.connect(self.time_out)
        self.timer_out_millisecs = 1000 #for 1 second

    def time_out(self):
        #negate seconds
        if self.total_seconds > 0:
            self.total_seconds -= 1
        else:
            self.stop_timer()
            self.timeOut.emit()

        self.setTime.emit(self.convert_secs_to_time(self.total_seconds))

    def convert_secs_to_time(self, secs):
        return str(timedelta(seconds=secs))

    #enable seconds adjustment from ui
    @Slot(int)
    def set_total_seconds(self, secs):
        self.initial_seconds = self.total_seconds
        self.total_seconds = secs

        self.setTime.emit(self.convert_secs_to_time(self.total_seconds))

    @Slot()
    def get_initial_time_values(self):
        time_string = self.convert_secs_to_time(self.total_seconds)
        times = time_string.split(":")

        self.setInitialTimeValues.emit(times)

    #timer manipulation
    @Slot()
    def start_timer(self):
        self.timer.start(self.timer_out_millisecs)

    @Slot()
    def reset_timer(self):
        #to initial
        self.set_total_seconds(self.initial_seconds)

    @Slot()
    def stop_timer(self):
        self.timer.stop()

if __name__ == "__main__":
    app = QGuiApplication(sys.argv)
    engine = QQmlApplicationEngine()

    #get context
    main = MainWindow()
    engine.rootContext().setContextProperty("backend", main)

    #load QML file
    engine.load(os.fspath(Path(__file__).resolve().parent / "main.qml"))

    if not engine.rootObjects():
        sys.exit(-1)
    sys.exit(app.exec())
