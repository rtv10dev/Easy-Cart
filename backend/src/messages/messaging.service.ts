import { Injectable, Logger } from '@nestjs/common';
import { credential, initializeApp, messaging, app } from 'firebase-admin';
import config from '../../config';
import { Product } from 'src/products/interfaces/product.interface';
import cert from '../../config/serviceAccountKey.json';

@Injectable()
export class MessagingService {
  private readonly logger = new Logger(MessagingService.name);
  private topic = config.firebase.topic;

  constructor() {
    this._configure();
  }

  async sendMessage(product?: Product) {
    try {
      var message = {};
      if (product) {
        message = {
          notification: {
            title: 'New Product added',
            body: `${product.user} added ${product.name}`,
          },
          data: {
            click_action: 'FLUTTER_NOTIFICATION_CLICK',
            name: product.name,
            user: product.user,
          },
        };
      } else {
        message = {
          data: {
            empty: "true"
          }
        }
      }

      this.logger.log(`Firebase message => ${JSON.stringify(message)}`);
      return await messaging().sendToTopic(this.topic, message);
    } catch (err) {
      this.logger.error(`sendMessage ---- ${err}`);
      throw err;
    }
  }

  _configure(): void {
    const credentialObject = {
      projectId: cert.project_id,
      clientEmail: cert.client_email,
      privateKey: cert.private_key,
    };

    initializeApp({
      credential: credential.cert(credentialObject),
      databaseURL: config.firebase.databaseURL,
    });
  }
}
