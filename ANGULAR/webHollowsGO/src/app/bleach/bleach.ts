import {AfterViewInit, Component, ElementRef, ViewChild} from '@angular/core';

@Component({
  selector: 'app-bleach',
  imports: [],
  templateUrl: './bleach.html',
  styleUrl: './bleach.css'
})
export class BleachInfoComponent implements AfterViewInit {
  @ViewChild('bleachVideo') bleachVideo!: ElementRef<HTMLVideoElement>;

  ngAfterViewInit(): void {
    const video = this.bleachVideo.nativeElement;

    const observer = new IntersectionObserver(
      ([entry]) => {
        if (entry.isIntersecting) {
          video.play();
        } else {
          video.pause();
        }
      },
      {
        root: null,
        threshold: 1
      }
    );

    observer.observe(video);
  }
}
