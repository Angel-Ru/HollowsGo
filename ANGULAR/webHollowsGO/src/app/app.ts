import { Component, OnInit, OnDestroy, ChangeDetectorRef } from '@angular/core';
import { NgStyle } from '@angular/common';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  standalone: true,  // si uses standalone components
  imports: [NgStyle],
  styleUrls: ['./app.component.css']
})
export class AppComponent implements OnInit, OnDestroy {
  backgrounds = [
    'url(https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/WEB/tjytgu9aljl2bdzjc0d4)',
    'url(https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/WEB/cre3pjxh5xt44firil1k)',
    'url(https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=1470&q=80)'
  ];

  currentBackgroundIndex = 0;
  intervalId?: any;

  constructor(private cdr: ChangeDetectorRef) {}

  get backgroundImage(): string {
    return this.backgrounds[this.currentBackgroundIndex];
  }

  ngOnInit() {
    this.intervalId = setInterval(() => {
      this.changeBackground();
      this.cdr.detectChanges();  // força Angular a detectar el canvi
    }, 20000); // cada 20 segons
  }

  ngOnDestroy() {
    if (this.intervalId) {
      clearInterval(this.intervalId);
    }
  }

  changeBackground() {
    this.currentBackgroundIndex = (this.currentBackgroundIndex + 1) % this.backgrounds.length;
  }
}
