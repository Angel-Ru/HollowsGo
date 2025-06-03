import {AfterViewInit, Component, ElementRef, ViewChild, OnDestroy} from '@angular/core';

@Component({
  selector: 'app-bleach',
  templateUrl: './bleach.html',
  styleUrls: ['./bleach.css']
})
export class BleachInfoComponent implements AfterViewInit, OnDestroy {
  @ViewChild('bleachVideo') bleachVideo!: ElementRef<HTMLVideoElement>;

  private observer!: IntersectionObserver;

  ngAfterViewInit(): void {
    const video = this.bleachVideo.nativeElement;

    // Callback per l'observer
    const handleIntersection = ([entry]: IntersectionObserverEntry[]) => {
      this.toggleVideoPlayback(entry.isIntersecting);
    };

    // Crear l'observer amb threshold 0
    this.observer = new IntersectionObserver(handleIntersection, {
      root: null,
      threshold: 0
    });

    this.observer.observe(video);

    // Comprovar manualment la visibilitat inicial
    this.checkAndToggleVideo();

    // Afegir listeners per scroll i resize per cobrir canvis posteriors
    window.addEventListener('scroll', this.checkAndToggleVideo);
    window.addEventListener('resize', this.checkAndToggleVideo);
  }

  ngOnDestroy(): void {
    if (this.observer) {
      this.observer.disconnect();
    }
    window.removeEventListener('scroll', this.checkAndToggleVideo);
    window.removeEventListener('resize', this.checkAndToggleVideo);
  }

  // Funció per activar o pausar el vídeo segons visibilitat
  private toggleVideoPlayback(visible: boolean) {
    const video = this.bleachVideo.nativeElement;
    if (visible) {
      video.play().catch(() => {});
    } else {
      video.pause();
    }
  }

  // Funció per comprovar si el vídeo està visible i trucar toggleVideoPlayback
  private checkAndToggleVideo = () => {
    const video = this.bleachVideo.nativeElement;
    const rect = video.getBoundingClientRect();
    const windowHeight = window.innerHeight || document.documentElement.clientHeight;
    const windowWidth = window.innerWidth || document.documentElement.clientWidth;

    // Comprovem si hi ha intersecció amb la finestra visible
    const isVisible =
      rect.bottom > 0 &&
      rect.top < windowHeight &&
      rect.right > 0 &&
      rect.left < windowWidth;

    this.toggleVideoPlayback(isVisible);
  };
}
