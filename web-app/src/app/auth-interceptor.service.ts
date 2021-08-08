import { Injectable } from '@angular/core';
import { HttpEvent, HttpInterceptor, HttpHandler, HttpRequest, HttpErrorResponse } from '@angular/common/http';
import { catchError, filter, take, switchMap } from "rxjs/operators";
import { Observable, throwError } from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class AuthInterceptorService implements HttpInterceptor {
 

  intercept(req: HttpRequest<any>, next: HttpHandler) {
   /*  const accessToken = this.oktaAuth.getAccessToken(); */
    console.log("Interception In Progress");
    const token = localStorage.getItem('token');
    req = req.clone({ headers: req.headers.set('x-access-token', '' +token ) });
    req = req.clone({ headers: req.headers.set('Content-Type', 'application/json') });
    req = req.clone({ headers: req.headers.set('Accept', 'application/json') });
    console.log("Interception In Progress");
    return next.handle(req)
        .pipe(
           catchError((error: HttpErrorResponse) => {
                //401 UNAUTHORIZED
                if (error && error.status === 401) {
                    console.log("ERROR 401 UNAUTHORIZED")
                }
                const err = error.error.message || error.statusText;
                return throwError(error);                    
           })
        );
  }  
}
