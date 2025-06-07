import { AfterViewInit, Component, ElementRef, ViewChild } from '@angular/core';

@Component({
  selector: 'app-bleach',
  templateUrl: './bleach.html',
  styleUrls: ['./bleach.css']
})
export class BleachInfoComponent implements AfterViewInit {
  @ViewChild('bleachVideo') bleachVideo!: ElementRef<HTMLVideoElement>;

  ngAfterViewInit(): void {
    const video = this.bleachVideo.nativeElement;

    // Assegura que està muted (important per autoplay)
    video.muted = true;

    // Esperem que la pàgina estigui carregada i layout estable
    setTimeout(() => {
      const rect = video.getBoundingClientRect();
      const windowHeight = window.innerHeight || document.documentElement.clientHeight;
      const windowWidth = window.innerWidth || document.documentElement.clientWidth;

      // Comprovem si és visible (tot i parcialment)
      const isVisible = rect.bottom > 0 && rect.top < windowHeight && rect.right > 0 && rect.left < windowWidth;

      if (isVisible) {
        video.play().catch(() => {
          // Si falla, no fem res però evitem errors
        });
      }
    }, 100);

    // Observer per pausar/reproduir segons visibilitat posterior
    const observer = new IntersectionObserver(
      ([entry]) => {
        if (entry.isIntersecting) {
          video.play().catch(() => {});
        } else {
          video.pause();
        }
      },
      { threshold: 0 }
    );

    observer.observe(video);
  }
}
