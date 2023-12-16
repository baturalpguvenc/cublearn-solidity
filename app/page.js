// pages/index.js
import CertificateMinter from '../components/CertificateMinter';
import CertificateViewer from '../components/CertificateViewer';

const Home = () => {
  return (
    <div>
      <CertificateMinter />
      <CertificateViewer />
    </div>
  );
};

export default Home;
